import Toybox.Math;
import Toybox.Lang;

class MinutesHandSystem {
    static function create(components) {
        var inst = new MinutesHandSystem(components);

        return inst;
    }

    static function isCompatible(entity) {
        return entity.hasKey(:time)
            && entity.hasKey(:minutesHand)
            && entity.hasKey(:polygon);
    }

    var engine;
    var time as TimeComponent;
    var hand as HandComponent;
    var polygon as ShapeComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (5 * 1000) as Long; // skip updates for 5 secs
    var accumulatedTime = 0 as Long;

    var PIDiv30 = Math.PI / 30.0;
    var length = 0;
    var transformMatrix = [[0, 0], [0, 0]];

    function initialize(components) {
        self.engine = components[:engine];
        self.time = components[:time];
        self.hand = components[:minutesHand];
        self.polygon = components[:polygon];
        self.stats = components[:stats];
    }

    function init() {
        self.length = self.hand.coordinates.size();

        var result = new [self.length];
        for (var index = 0; index < self.length; index += 1) {
            var idxLength = self.hand.coordinates[index][1].size();
            var res = new [idxLength];
            for (var idx = 0; idx < idxLength; idx++) {
                res[idx] = [0,0];
            }
            result[index] = [self.hand.coordinates[index][0], res, idxLength];
        }

        self.polygon.mesh = result;
        self.polygon.length = result.size();
    }

    function update(deltaTime) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        var angle = (self.time.minutes + self.time.seconds / 60.0) * self.PIDiv30;

        self.transformMatrix[0][0] = Math.cos(angle);
        self.transformMatrix[0][1] = Math.sin(angle);
        self.transformMatrix[1][0] = -self.transformMatrix[0][1];
        self.transformMatrix[1][1] = self.transformMatrix[0][0];

        for (var index = 0; index < length; index += 1) {
            var idxLength = self.polygon.mesh[index][2]; // self.hand.coordinates[index][1].size();
            var res = self.polygon.mesh[index][1];
            var turnedMesh = arrayMultiply(res, self.hand.coordinates[index][1], transformMatrix, idxLength, 2, 2);
            for (var idx = 0; idx < idxLength; idx++) {
                res[idx][0] = turnedMesh[idx][0] + self.engine.centerPoint[0];
                res[idx][1] = turnedMesh[idx][1] + self.engine.centerPoint[1];
            }
        }
    }
}

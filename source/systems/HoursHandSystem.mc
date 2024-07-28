import Toybox.Lang;
using Toybox.Math;

class HoursHandSystem {
    static function create(components) {
        var inst = new HoursHandSystem(components);

        return inst;
    }

    static function isCompatible(entity) as Boolean {
        return entity.hasKey(:time) and entity.hasKey(:hoursHand) and entity.hasKey(:polygon);
    }

    var engine as Engine;
    var time as TimeComponent;
    var hand as HandComponent;
    var polygon as ShapeComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (5 * 60 * 1000) as Long; // skip updates for 5 mins
    var accumulatedTime = 0 as Long;

    var length = 0;

    function initialize(components) {
        self.engine = components[:engine];
        self.time = components[:time];
        self.hand = components[:hoursHand];
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
            result[index] = [self.hand.coordinates[index][0], res];
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

        var angle = Math.PI/6 * (1.0*self.time.hours + self.time.minutes / 60.0);

        var sinCos = [Math.cos(angle), Math.sin(angle)];
        var transformMatrix = [
            sinCos,
            [-sinCos[1], sinCos[0]],
        ];

        for (var index = 0; index < length; index += 1) {
            var idxLength = self.hand.coordinates[index][1].size();
            var res = self.polygon.mesh[index][1];
            var turnedMesh = arrayMultiply(res, self.hand.coordinates[index][1], transformMatrix, idxLength, 2, 2);
            for (var idx = 0; idx < idxLength; idx++) {
                res[idx][0] = turnedMesh[idx][0] + self.engine.centerPoint[0];
                res[idx][1] = turnedMesh[idx][1] + self.engine.centerPoint[1];
            }
        }
    }
}

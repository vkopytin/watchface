import Toybox.Lang;
using Toybox.Math;

function hoursHandSystemCreate(components) {
    var inst = new HoursHandSystem(components);

    return inst;
}

function hoursHandSystemIsCompatible(entity) as Boolean {
    return entity.hasKey(:time) and entity.hasKey(:hoursHand) and entity.hasKey(:polygon);
}

class HoursHandSystem {
    var engine as Engine;
    var time as TimeComponent;
    var hand as HandComponent;
    var polygon as ShapeComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (5 * 60 * 1000) as Long; // skip updates for 5 mins
    var accumulatedTime = 0 as Long;

    function initialize(components) {
        self.engine = components[:engine];
        self.time = components[:time];
        self.hand = components[:hoursHand];
        self.polygon = components[:polygon];
        self.stats = components[:stats];
    }

    function init() {
        
    }

    function update(deltaTime) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        var screenCenterPoint = self.engine.centerPoint;

        var angle = Math.PI/6 * (1.0*self.time.hours + self.time.minutes / 60.0);

        var length = self.hand.coordinates.size();
        var result = new [length];

        var sinCos = [Math.cos(angle), Math.sin(angle)];
        var transformMatrix = [
            sinCos,
            [-sinCos[1], sinCos[0]],
        ];
        var moveMatrix = [screenCenterPoint];

        var oldPoint = new [1];
        for (var index = 0; index < length; index += 1) {
            var idxLength = self.hand.coordinates[index][1].size();
            var res = new [idxLength];
            for (var idx = 0; idx < idxLength; idx++) {
                oldPoint[0] = self.hand.coordinates[index][1][idx];
                var point = add(multiply(oldPoint, transformMatrix), moveMatrix);
                res[idx] = point[0];
            }
            result[index] = [self.hand.coordinates[index][0], res];
        }

        self.polygon.color = self.hand.color;
        self.polygon.mesh = result;
    }
}

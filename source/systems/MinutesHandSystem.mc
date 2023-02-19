import Toybox.Math;
import Toybox.Lang;

function minutesHandSystemCreate(components) {
    var inst = new MinutesHandSystem(components);

    return inst;
}

function minutesHandSystemIsCompatible(entity) {
    return entity.hasKey(:time)
        && entity.hasKey(:minutesHand)
        && entity.hasKey(:polygon);
}

class MinutesHandSystem {
    var engine;
    var time as TimeComponent;
    var hand as HandComponent;
    var polygon as ShapeComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (5 * 1000) as Long; // skip updates for 5 secs
    var accumulatedTime = self.fastUpdate + 1 as Long;

    function initialize(components) {
        self.engine = components[:engine];
        self.time = components[:time];
        self.hand = components[:minutesHand];
        self.polygon = components[:polygon];
        self.stats = components[:stats];
    }

    function init() {
        
    }

    function update(deltaTime) {
        self.accumulatedTime += deltaTime;
        if (self.accumulatedTime < self.fastUpdate) {
            return;
        }

        self.accumulatedTime = 0;
        var screenCenterPoint = self.engine.centerPoint;

        var angle = (self.time.minutes / 30.0 + self.time.seconds / 60.0 / 30.0) * Math.PI;

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
            oldPoint[0] = self.hand.coordinates[index];
            var point = add(multiply(oldPoint, transformMatrix), moveMatrix);
            result[index] = point[0];
        }

        self.polygon.color = self.hand.color;
        self.polygon.mesh = [result];
    }

    function render(dc, context) {
        
    }
}

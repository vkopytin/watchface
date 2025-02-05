import Toybox.Math;
import Toybox.Lang;

function secondsHandSystemCreate(components) {
    var inst = new SecondsHandSystem(components);

    return inst;
}

function secondsHandSystemIsCompatible(entity) {
    return entity.hasKey(:time) and entity.hasKey(:secondsHand) and entity.hasKey(:polygon);
}

function max(left, right) {
    if (left > right) {
        return left;
    }
    return right;
}

function min(left, right) {
    if (left < right) {
        return left;
    }
    return right;
}

class SecondsHandSystem {
    var engine as Engine;
    var time as TimeComponent;
    var hand as HandComponent;
    var polygon as ShapeComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (1 * 1000) as Long; // keep fast updates for 1 secs
    var accumulatedTime = 0 as Long;

    function initialize(components) {
        self.engine = components[:engine];
        self.time = components[:time];
        self.hand = components[:secondsHand];
        self.polygon = components[:polygon];
        self.stats = components[:stats];
    }

    function init() {
        
    }

    function update(deltaTime) {
        var screenCenterPoint = self.engine.centerPoint;

        var angle = (self.time.seconds / 30.0) * Math.PI;

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

        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }
        self.accumulatedTime = self.fastUpdate;

        var minX = self.engine.width;
        var minY = self.engine.height;
        var maxX = 0;
        var maxY = 0;
        for (var index = 0; index < length; index += 1) {
            var point = self.polygon.mesh[0][index];
            minX = min(minX, point[0]);
            minY = min(minY, point[1]);
            maxX = max(maxX, point[0]);
            maxY = max(maxY, point[1]);
        }
        self.engine.clipArea[0][0] = max(0, minX - 15);
        self.engine.clipArea[0][1] = max(0, minY - 15);
        self.engine.clipArea[1][0] = min(self.engine.width, maxX - self.engine.clipArea[0][0] + 15);
        self.engine.clipArea[1][1] = min(self.engine.height, maxY - self.engine.clipArea[0][1] + 15);
    }
}

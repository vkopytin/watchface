import Toybox.Math;
import Toybox.Lang;

function minuteTicksSystemCreate(components) {
    var inst = new MinuteTicksSystem(components);

    return inst;
}

function minuteTicksSystemIsCompatible(entity) {
    return entity.hasKey(:minuteTicks);
}

class MinuteTicksSystem {
    var engine;
    var minuteTicks as MinuteTicksComponent;
    var polygon as ShapeComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (60 * 1000) as Long; // skip updates for min
    var accumulatedTime = self.fastUpdate + 1 as Long;

    function initialize(components) {
        self.engine = components[:engine];
        self.minuteTicks = components[:minuteTicks];
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
        var increment = 1;
        var ticksCount = 60 / increment;
        var coords = self.minuteTicks.mesh;
        var polygons = new [ticksCount];
        var length = coords.size();

        for (var i = 0; i < ticksCount; i += 1) {
            var angle = increment * i * Math.PI / 30;

            var result = new [length];

            var transformMatrix = [
                [Math.cos(angle), Math.sin(angle)],
                [-Math.sin(angle), Math.cos(angle)],
            ];
            var moveMatrix = [screenCenterPoint];

            for (var index = 0; index < length; index += 1) {
                var oldPoint = new [1];
                oldPoint[0] = coords[index];
                var point = add(multiply(oldPoint, transformMatrix), moveMatrix);
                result[index] = point[0];
            }
            polygons[i] = result;
        }

        self.polygon.color = self.minuteTicks.color;
        self.polygon.mesh = polygons;
    }
    
    function render(dc, context) {

    }
}

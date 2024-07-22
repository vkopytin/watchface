import Toybox.Lang;
import Toybox.Math;

class HourTicksSystem {
    function create(components) {
        var inst = new HourTicksSystem(components);

        return inst;
    }

    function isCompatible(entity) {
        return entity.hasKey(:hourTicks) and entity.hasKey(:polygon);
    }

    var engine;
    var hourTicks as HourTicksComponent;
    var polygon as ShapeComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (60 * 1000) as Long; // skip updates for min
    var accumulatedTime = 0 as Long;

    function initialize(components) {
        self.engine = components[:engine];
        self.hourTicks = components[:hourTicks];
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
        var coords = self.hourTicks.mesh;
        var increment = 5;
        var ticksCount = 60 / increment;
        var polygons = new [ticksCount];
        var length = coords.size();

        var oldPoint = new [1];
        for (var i = 0; i < ticksCount; i += 1) {
            var angle = increment * i * Math.PI / 30;

            var result = new [length];

            var sinCos = [Math.cos(angle), Math.sin(angle)];
            var transformMatrix = [
                sinCos,
                [-sinCos[1], sinCos[0]],
            ];
            var moveMatrix = [screenCenterPoint];

            for (var index = 0; index < length; index += 1) {
                oldPoint[0] = coords[index];
                var point = add(multiply(oldPoint, transformMatrix), moveMatrix);
                result[index] = point[0];
            }
            polygons[i] = [self.hourTicks.color, result];
        }

        self.polygon.mesh = polygons;
        self.polygon.length = polygons.size();
    }
}

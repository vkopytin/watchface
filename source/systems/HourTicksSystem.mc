import Toybox.Lang;
import Toybox.Math;

function hourTicksSystemCreate(components) {
    var inst = new HourTicksSystem(components);

    return inst;
}

function hourTicksSystemIsCompatible(entity) {
    return entity.hasKey(:hourTicks);
}

class HourTicksSystem {
    var engine;
    var hourTicks as HourTicksComponent;
    var polygon as ShapeComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (60 * 1000) as Long; // skip updates for min
    var accumulatedTime = self.fastUpdate + 1 as Long;

    function initialize(components) {
        self.engine = components[:engine];
        self.hourTicks = components[:hourTicks];
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
        var coords = self.hourTicks.mesh;
        var increment = 5;
        var ticksCount = 60 / increment;
        var polygons = new [ticksCount];
        var length = coords.size();

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
                var oldPoint = new [1];
                oldPoint[0] = coords[index];
                var point = add(multiply(oldPoint, transformMatrix), moveMatrix);
                result[index] = point[0];
            }
            polygons[i] = result;
        }

        self.polygon.color = self.hourTicks.color;
        self.polygon.mesh = polygons;
    }

    function render(dc, context) {

    }
}

class UpdateHourTicks {
function exec(entity, components) {
    var context = components[:context];
    var hourTicks = components[:hourTicks];
    var polygon = components[:polygon];

    hourTicks.accumulatedTime -= context.deltaTime;
    if (hourTicks.accumulatedTime > 0) {
        return;
    }
    hourTicks.accumulatedTime = hourTicks.fastUpdate;

    var screenCenterPoint = context.centerPoint;
    var coords = hourTicks.mesh;
    var increment = 5;
    var ticksCount = 60 / increment;
    var polygons = new [ticksCount];
    var length = coords.size();

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
            var oldPoint = new [1];
            oldPoint[0] = coords[index];
            var point = add(multiply(oldPoint, transformMatrix), moveMatrix);
            result[index] = point[0];
        }
        polygons[i] = result;
    }

    polygon.color = hourTicks.color;
    polygon.mesh = polygons;
}
}

function makeUpdateHourTicksDelegate() {
    var inst = new UpdateHourTicks();

    return inst;
}

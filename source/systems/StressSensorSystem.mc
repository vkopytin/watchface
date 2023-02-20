import Toybox.Lang;
import Toybox.Math;
import Toybox.Graphics;

function stressSensorSystemCreate(components) as StressSensorSystem {
    var inst = new StressSensorSystem(components);

    return inst;
}

function stressSensorSystemIsCompatible(entity) as Boolean {
    return entity.hasKey(:stress);
}

class StressSensorSystem {
    var engine as Engine;
    var stress as StressSensorComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (5 * 1000) as Long; // keep fast updates for 5 secs
    var accumulatedTime = self.fastUpdate + 1 as Long;

    function initialize(components) {
        self.engine = components[:engine] as Engine;
        self.stress = components[:stress] as StressSensorComponent;
        self.stats = components[:stats];
    }

    function init() {
        
    }

    function update(deltaTime as Long) {
        self.accumulatedTime += deltaTime;
        if (self.accumulatedTime < self.fastUpdate) {
            return;
        }

        self.accumulatedTime = 0;

        var screenCenterPoint = self.engine.centerPoint;
        var moveMatrix = [screenCenterPoint];
        self.stress.point = add([self.stress.position], moveMatrix)[0];

        var stressIterator = Toybox.SensorHistory.getStressHistory({:period=>1});
		var sample = stressIterator.next();
        if (sample != null) {
            self.stress.value = sample.data;
        }
    }

    function render(dc, context) {
        var stressStr = self.stress.value.format("%d");
        var point = self.stress.point;
        dc.drawText(point[0], point[1], Graphics.FONT_SYSTEM_XTINY, stressStr, Graphics.TEXT_JUSTIFY_CENTER); // Using Font
    }
}

class UpdateStressSensor {
function exec(entity, components) {
    var stress = components[:stress];
    var context = components[:context];
    var titles = components[:titles];

    stress.accumulatedTime -= context.deltaTime;
    if (stress.accumulatedTime > 0) {
        return;
    }

    stress.accumulatedTime = context.deltaTime;

    var screenCenterPoint = context.centerPoint;
    var moveMatrix = [screenCenterPoint];
    stress.point = add([stress.position], moveMatrix)[0];

    var stressIterator = Toybox.SensorHistory.getStressHistory({:period => 1});
    var sample = stressIterator.next();
    if (sample != null) {
        stress.value = sample.data;
    }

    var stressStr = stress.value.format("%d");
    var point = stress.point;
    titles.color = stress.color;
    titles.titles = [
        [point[0], point[1], Graphics.FONT_SYSTEM_XTINY, stressStr, Graphics.TEXT_JUSTIFY_CENTER]
    ];
}
}

function makeUpdateStressSensorDelegate() {
    return new UpdateStressSensor();
}

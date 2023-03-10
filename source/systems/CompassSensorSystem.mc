import Toybox.Lang;
import Toybox.Math;
using Toybox.Sensor;

class CompassSensorSystem {
    function create(components) as CompassSensorSystem {
        var inst = new CompassSensorSystem(components);

        return inst;
    }

    function isCompatible(entity) as Boolean {
        return entity.hasKey(:compass);
    }

    var engine as Engine;
    var compass as CompassSensorComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (60 * 1000) as Long; // keep fast updates for min
    var accumulatedTime = 0 as Long;

    function initialize(components) {
        self.engine = components[:engine] as Engine;
        self.compass = components[:compass] as CompassSensorComponent;
        self.stats = components[:stats];
    }

    function init() {
        
    }

    function update(deltaTime as Long) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        var screenCenterPoint = self.engine.centerPoint;
        var moveMatrix = [screenCenterPoint];
        self.compass.point = add([self.compass.position], moveMatrix)[0];
    }

    function render(dc, context) {
        var point = self.compass.point;
        context.dc.drawText(point[0], point[1], Graphics.FONT_SYSTEM_XTINY, self.compass.spStr, Graphics.TEXT_JUSTIFY_CENTER); // Using Font
    }
}

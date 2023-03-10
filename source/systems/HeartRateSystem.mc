import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Graphics;
import Toybox.ActivityMonitor;

class HeartRateSystem {
    static function setup(systems, entity, api) {
        if (entity.hasKey(:heartRate)) {
            systems.add(new HeartRateSystem(entity, api));
        }
    }

    var api as API_Functions;
    var engine as Engine;
    var heartRate as HeartRateComponent;

    var fastUpdate = (5 * 1000) as Long; // keep fast updates for minute
    var accumulatedTime = 0 as Long;

    function initialize(components, api as API_Functions) {
        self.api = api;
        self.engine = components[:engine] as Engine;
        self.heartRate = components[:heartRate] as HeartRateComponent;
    }

    function init() {
        
    }

    function update(deltaTime as Long) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        var heartRate = Activity.getActivityInfo().currentHeartRate; 
        if (heartRate == null) {
            var HRH = ActivityMonitor.getHeartRateHistory(1, true);
            var HRS = HRH.next();
            if(HRS != null && HRS.heartRate != ActivityMonitor.INVALID_HR_SAMPLE){
                heartRate = HRS.heartRate;
            }
        }

        if (heartRate == null) {
            return;
        }

        self.heartRate.value = heartRate.format("%02d");
    }

    function render(dc, context) {
        context.dc.setColor(self.heartRate.color, Graphics.COLOR_TRANSPARENT);
        context.dc.drawText(
            self.heartRate.position[0], self.heartRate.position[1],
            Graphics.FONT_SYSTEM_XTINY,
            self.heartRate.value,
            Graphics.TEXT_JUSTIFY_LEFT
        );

    }
}

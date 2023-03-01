import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Graphics;
import Toybox.ActivityMonitor;

class StepsSystem {
    static function create(components, api as API_Functions) as StepsSystem {
        var inst = new StepsSystem(components, api);

        return inst;
    }

    static function isCompatible(entity) as Boolean {
        return entity.hasKey(:steps);
    }

    var api as API_Functions;
    var engine as Engine;
    var steps as StepsComponent;

    var fastUpdate = (2 * 1000) as Long; // keep fast updates for minute
    var accumulatedTime = 0 as Long;

    function initialize(components, api as API_Functions) {
        self.api = api;
        self.engine = components[:engine] as Engine;
        self.steps = components[:steps] as StepsComponent;
    }

    function init() {
        self.steps.distanceUnits = System.getDeviceSettings().distanceUnits;
    }

    function update(deltaTime as Long) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        var activityInfo = ActivityMonitor.getInfo();
        if (activityInfo == null) {
            return;
        }

        var distStr = activityInfo.steps;
        self.steps.value = distStr;

		var stepDistance = activityInfo.distance;//.toString();
		var unit = "?";

		if (stepDistance != null) {
			if (self.steps.distanceUnits == System.UNIT_METRIC) {
                unit = " km";
                stepDistance = stepDistance * 0.00001;
			} else {
                unit = " mi";
                stepDistance = stepDistance * 0.00001 * 0.621371;
			}
		} else {
			stepDistance = 0;
		}

		if (stepDistance >= 100) {
			distStr = stepDistance.format("%.0f");
		} else {
			distStr = stepDistance.format("%.1f");
        }
        self.steps.distance = distStr + unit;    		
    }

    function render(dc, context) {
        dc.setColor(self.steps.color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            self.steps.position[0], self.steps.position[1],
            Graphics.FONT_SYSTEM_XTINY,
            self.steps.value,
            Graphics.TEXT_JUSTIFY_LEFT
        );
        dc.drawText(
            self.steps.position[0], self.steps.position[1] + 14,
            Graphics.FONT_SYSTEM_XTINY,
            self.steps.distance,
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }
}

import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
using Toybox.Sensor;

class BodyBatterySystem {
    static function create(components) as BodyBatterySystem {
        var inst = new BodyBatterySystem(components);

        return inst;
    }

    static function isCompatible(entity) as Boolean {
        return entity.hasKey(:bodyBattery);
    }

    var engine as Engine;
    var bodyBattery as BodyBatteryComponent;

    var chargeAmount;

    var fastUpdate = (60 * 1000) as Long; // keep fast updates for hour
    var accumulatedTime = 0 as Long;

    function initialize(components) {
        self.engine = components[:engine] as Engine;
        self.bodyBattery = components[:bodyBattery] as BodyBatteryComponent;
    }

    function init() {

    }

    function update(deltaTime as Long) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;
        var bbIterator = Toybox.SensorHistory.getBodyBatteryHistory({ :period => 1 });
        var sample = bbIterator.next();

        self.bodyBattery.value = sample.data.format("%d");
    }

    function render(dc, context) {
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(self.bodyBattery.position[0], self.bodyBattery.position[1], Graphics.FONT_SYSTEM_XTINY, self.bodyBattery.value, Graphics.TEXT_JUSTIFY_CENTER);
    }
}

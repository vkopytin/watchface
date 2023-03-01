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

    var fastUpdate = (5 * 1000) as Long; // keep fast updates for 5 secs
    var accumulatedTime = 0 as Long;

    function initialize(components) {
        self.engine = components[:engine] as Engine;
        self.bodyBattery = components[:bodyBattery] as BodyBatteryComponent;
    }

function init() {
        self.chargeAmount = WatchUi.loadResource(Rez.Drawables.chargeAmount);
    }

    function update(deltaTime as Long) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        var bbIterator = Toybox.SensorHistory.getBodyBatteryHistory({ :period => 1 });
        if (bbIterator == null) {
            return;
        }
        var sample = bbIterator.next();

        if (sample == null) {
            return;
        }

        var pwr = sample.data;
        var step = 12;
        var offset = 162;

        if (pwr > 95) {
            self.bodyBattery.deltaIndex = offset;
        } else if (pwr > 90) {
            self.bodyBattery.deltaIndex = offset - step;
        } else if (pwr > 85){
            self.bodyBattery.deltaIndex = offset - 2 * step;
        } else if (pwr > 80) {
            self.bodyBattery.deltaIndex = offset - 3 * step;
        } else if (pwr > 75) {
            self.bodyBattery.deltaIndex = offset - 4 * step;
        } else if (pwr > 70) {
            self.bodyBattery.deltaIndex = offset - 5 * step;
        } else if (pwr > 65) {
            self.bodyBattery.deltaIndex = offset - 6 * step;
        } else if (pwr > 60) {
            self.bodyBattery.deltaIndex = offset - 7 * step;
        } else if (pwr > 55){
            self.bodyBattery.deltaIndex = offset - 8 * step;
        } else if (pwr > 50) {
            self.bodyBattery.deltaIndex = offset - 9 * step;
        } else if (pwr > 45) {
            self.bodyBattery.deltaIndex = offset - 10 * step;
        } else if (pwr > 40) {
            self.bodyBattery.deltaIndex = offset - 11 * step;
        } else if (pwr > 35) {
            self.bodyBattery.deltaIndex = offset - 12 * step;
        } else if (pwr > 30) {
            self.bodyBattery.deltaIndex = offset - 13 * step;
        } else if (pwr > 25){
            self.bodyBattery.deltaIndex = offset - 14 * step;
        } else if (pwr > 20) {
            self.bodyBattery.deltaIndex = offset - 15 * step;
        } else if (pwr > 15) {
            self.bodyBattery.deltaIndex = offset - 16 * step;
        } else if (pwr > 10) {
            self.bodyBattery.deltaIndex = offset - 17 * step;
        } else if (pwr > 5) {
            self.bodyBattery.deltaIndex = offset - 18 * step;
        } else {
            self.bodyBattery.deltaIndex = offset - 19 * step;
        }
    }

    function render(dc, context) {
        dc.setClip(13, 162, 115, 12);
        dc.drawBitmap(13, self.bodyBattery.deltaIndex, self.chargeAmount);
        dc.clearClip();
    }
}

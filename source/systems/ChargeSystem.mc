import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
using Toybox.Sensor;

class ChargeSystem {
    static function create(components) as ChargeSystem {
        var inst = new ChargeSystem(components);

        return inst;
    }

    static function isCompatible(entity) as Boolean {
        return entity.hasKey(:charge);
    }

    var engine as Engine;
    var charge as ChargeComponent;

    var chargeAmount;

    var fastUpdate = (60 * 1000) as Long; // keep fast updates for hour
    var accumulatedTime = 0 as Long;

    function initialize(components) {
        self.engine = components[:engine] as Engine;
        self.charge = components[:charge] as ChargeComponent;
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

        var stats = System.getSystemStats();
        var pwr = stats.battery;
        var step = 12;
        var offset = 162;

        if (pwr > 95) {
            self.charge.deltaIndex = offset;
        } else if (pwr > 90) {
            self.charge.deltaIndex = offset - step;
        } else if (pwr > 85){
            self.charge.deltaIndex = offset - 2 * step;
        } else if (pwr > 80) {
            self.charge.deltaIndex = offset - 3 * step;
        } else if (pwr > 75) {
            self.charge.deltaIndex = offset - 4 * step;
        } else if (pwr > 70) {
            self.charge.deltaIndex = offset - 5 * step;
        } else if (pwr > 65) {
            self.charge.deltaIndex = offset - 6 * step;
        } else if (pwr > 60) {
            self.charge.deltaIndex = offset - 7 * step;
        } else if (pwr > 55){
            self.charge.deltaIndex = offset - 8 * step;
        } else if (pwr > 50) {
            self.charge.deltaIndex = offset - 9 * step;
        } else if (pwr > 45) {
            self.charge.deltaIndex = offset - 10 * step;
        } else if (pwr > 40) {
            self.charge.deltaIndex = offset - 11 * step;
        } else if (pwr > 35) {
            self.charge.deltaIndex = offset - 12 * step;
        } else if (pwr > 30) {
            self.charge.deltaIndex = offset - 13 * step;
        } else if (pwr > 25){
            self.charge.deltaIndex = offset - 14 * step;
        } else if (pwr > 20) {
            self.charge.deltaIndex = offset - 15 * step;
        } else if (pwr > 15) {
            self.charge.deltaIndex = offset - 16 * step;
        } else if (pwr > 10) {
            self.charge.deltaIndex = offset - 17 * step;
        } else if (pwr > 5) {
            self.charge.deltaIndex = offset - 18 * step;
        } else {
            self.charge.deltaIndex = offset - 19 * step;
        }
    }

    function render(dc, context) {
        dc.setClip(21, 162, 115, 12);
        dc.drawBitmap(21, self.charge.deltaIndex, self.chargeAmount);
        dc.clearClip();
    }
}

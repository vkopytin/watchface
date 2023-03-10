import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
using Toybox.Sensor;

class ChargeSystem {
    static function setup(systems, entity, api) {
        if (entity.hasKey(:charge) and entity.hasKey(:watchStatus)) {
            systems.add(new ChargeSystem(entity));
        }
    }

    var engine as Engine;
    var charge as ChargeComponent;
    var watchStatus as WatchStatusComponent;

    var chargeAmount;

    var fastUpdate = (60 * 1000) as Long; // keep fast updates for hour
    var accumulatedTime = 0 as Long;

    function initialize(components) {
        self.engine = components[:engine] as Engine;
        self.charge = components[:charge] as ChargeComponent;
        self.watchStatus = components[:watchStatus] as WatchStatusComponent;
    }

    function init() {
        self.chargeAmount = WatchUi.loadResource(Rez.Drawables.chargeAmountV);
    }

    function update(deltaTime as Long) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        var pwr = self.watchStatus.battery;
        var step = 14;
        var offset = 1;

        if (pwr > 95) {
            self.charge.deltaIndex = offset;
        } else if (pwr > 90) {
            self.charge.deltaIndex = offset - step;
        } else if (pwr > 80){
            self.charge.deltaIndex = offset - 2 * step;
        } else if (pwr > 70) {
            self.charge.deltaIndex = offset - 3 * step;
        } else if (pwr > 60) {
            self.charge.deltaIndex = offset - 4 * step;
        } else if (pwr > 50) {
            self.charge.deltaIndex = offset - 5 * step;
        } else if (pwr > 40) {
            self.charge.deltaIndex = offset - 6 * step;
        } else if (pwr > 30) {
            self.charge.deltaIndex = offset - 7 * step;
        } else if (pwr > 20){
            self.charge.deltaIndex = offset - 8 * step;
        } else if (pwr > 10) {
            self.charge.deltaIndex = offset - 9 * step;
        } else {
            self.charge.deltaIndex = offset - 10 * step;
        }
    }

    function render(dc, context) {
        //dc.setClip(13, 162, 115, 12);
        context.dc.drawBitmap(self.charge.deltaIndex, self.charge.position[1], self.chargeAmount);
        context.dc.clearClip();
    }
}

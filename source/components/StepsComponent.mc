import Toybox.Graphics;
import Toybox.System;
using Toybox.Lang;

class StepsComponent {
    static function create() as StepsComponent {
        var inst = new StepsComponent();

        return inst;
    }
    var color = 0x005555;
    var position = [80, 175];
    var value = "0000";
    var distance = "0000";
    var distanceUnits = System.UNIT_METRIC;

    var fastUpdate = (2 * 1000) as Lang.Long; // keep fast updates for minute
    var accumulatedTime = 0 as Lang.Long;
}

import Toybox.Graphics;
using Toybox.Lang;

class BodyBatteryComponent {
    static function create() {
        return new BodyBatteryComponent();
    }
    var value = "";
    var deltaIndex = 0;
    var color = 0x005555;
    var position = [75, 225];

    var chargeAmount;

    var fastUpdate = (5 * 1000) as Lang.Long; // keep fast updates for 5 secs
    var accumulatedTime = 0 as Lang.Long;
}

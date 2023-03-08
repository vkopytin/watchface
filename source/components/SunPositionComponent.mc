import Toybox.Graphics;
using Toybox.Lang;

class SunPositionComponent {
    static function create() {
        return new SunPositionComponent();
    }
    var isDay = true;
    var color = 0x005555;
    var position = [60, 40];
    var sunset = "-:--";
    var sunrise = "-:--";
    var locationDegrees = [51.107883, 17.038538];

    var chargeAmount;

    var fastUpdate = (60 * 60 * 1000) as Lang.Long; // keep fast updates for 5 sec
    var accumulatedTime = 0 as Lang.Long;
    var api;
}

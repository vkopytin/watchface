import Toybox.Lang;

class WatchStatusComponent {
    static function create() {
        return new WatchStatusComponent();
    }

    var battery = 0;
    var phoneConnected = false;
    var solarIntensity = -1;
    var tonesOn = false;
    var vibrateOn = false;
    var isSolarCharging = false;
    var solarStatusIcon = "6";
    var color = 0x005555;
    var enabledColor = 0x005555;
    var disabledColor = 0x55ffff;
    var position = [15, 144];

    var statusIcons;

    var fastUpdate = (5 * 1000) as Long; // keep fast updates for 5 sec
    var accumulatedTime = 0 as Long;
}

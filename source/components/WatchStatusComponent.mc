class WatchStatusComponent {
    static function create() {
        return new WatchStatusComponent();
    }
    var battery = 0;
    var phoneConnected = false;
    var solarIntensity = -1;
    var toneOn = false;
    var vibrationOn = false;
    var isSolarCharging = false;
    var solarStatusIcon = "6";
    var color = 0x005555;
    var enabledColor = 0x005555;
    var disabledColor = 0x55ffff;
    var position = [20, 120];
}

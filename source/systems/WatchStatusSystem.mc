import Toybox.Lang;

class WatchStatusSystem {
    static function create(components, api as API_Functions) as WatchStatusSystem {
        var inst = new WatchStatusSystem(components, api);

        return inst;
    }

    static function isCompatible(entity) as Boolean {
        return entity.hasKey(:watchStatus);
    }

    var api as API_Functions;

    var engine as Engine;
    var watchStatus as WatchStatusComponent;

    var statusIcons;

    var fastUpdate = (5 * 1000) as Long; // keep fast updates for 5 sec
    var accumulatedTime = 0 as Long;

    function initialize(components, api) {
        self.api = api;
        self.engine = components[:engine] as Engine;
        self.watchStatus = components[:watchStatus] as WatchStatusComponent;
    }

    function init() {
        self.statusIcons = WatchUi.loadResource(Rez.Fonts.system12);
    }

    function update(deltaTime as Long) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        var stats = System.getSystemStats();
        self.watchStatus.battery = stats.battery;
        self.watchStatus.solarIntensity = stats.solarIntensity;
        self.watchStatus.isSolarCharging = stats.solarIntensity > 0;
        if (self.watchStatus.isSolarCharging) {
            self.watchStatus.color = self.watchStatus.enabledColor;
            self.watchStatus.solarStatusIcon = "7";
        } else {
            self.watchStatus.color = self.watchStatus.disabledColor;
            self.watchStatus.solarStatusIcon = "6";
        }
    }

    function render(dc, context) {

    }
}
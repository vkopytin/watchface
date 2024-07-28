import Toybox.Lang;

class WatchStatusSystem {
    static function setup(systems, entity, api) {
        if (entity.hasKey(:watchStatus)) {
            systems.add(new WatchStatusSystem(entity, api));
        }
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
        if (stats != null) {
            self.watchStatus.battery = stats.battery;
            self.watchStatus.solarIntensity = stats.solarIntensity;
            self.watchStatus.isSolarCharging = stats.solarIntensity > 0;
            if (self.watchStatus.solarIntensity > 49) {
                self.watchStatus.color = self.watchStatus.enabledColor;
                self.watchStatus.solarStatusIcon = "7";
            } else if (self.watchStatus.solarIntensity > 24) {
                self.watchStatus.color = self.watchStatus.enabledColor;
                self.watchStatus.solarStatusIcon = "6";
            } else if (self.watchStatus.solarIntensity > 0) {
                self.watchStatus.color = self.watchStatus.enabledColor;
                self.watchStatus.solarStatusIcon = "5";
            } else {
                self.watchStatus.color = self.watchStatus.disabledColor;
                self.watchStatus.solarStatusIcon = "5";
            }
        }

        var settings = System.getDeviceSettings();
        if (settings == null) {
            return;
        }
        self.watchStatus.phoneConnected = settings.phoneConnected;
        self.watchStatus.vibrateOn = settings.vibrateOn;
        self.watchStatus.tonesOn = settings.tonesOn;
    }
}

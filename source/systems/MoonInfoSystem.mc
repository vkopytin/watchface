import Toybox.Lang;
import Toybox.Position;
import Toybox.Time;
import Toybox.Time.Gregorian;

class MoonInfoSystem {
    static function create(components, api) as MoonInfoSystem {
        return new MoonInfoSystem(components, api);
    }

    static function isCompatible(entity) {
        return entity.hasKey(:time) and entity.hasKey(:date) and entity.hasKey(:moon);
    }

    var api as API_Functions;
    var time as TimeComponent;
    var date as DateComponent;
    var moon as MoonInfoComponent;

    var fastUpdate = (60 * 60 * 1000) as Long; // skip updates for 1 hour
    var accumulatedTime = 0 as Long;

    var myInfo as Position.Info or Null;
    var images = {
        Rez.Drawables.Phase00 => null,
        Rez.Drawables.Phase17 => null,
        Rez.Drawables.Phase26 => null,
        Rez.Drawables.Phase35 => null,
        Rez.Drawables.Phase44 => null,
        Rez.Drawables.Phase53 => null,
        Rez.Drawables.Phase62 => null,
        Rez.Drawables.Phase71 => null,
    };

    function initialize(components, api) {
        self.api = api;
        self.time = components[:time];
        self.date = components[:date];
        self.moon = components[:moon];
    }

    function init() {
        self.myInfo = Position.getInfo();
        self.images[Rez.Drawables.Phase00] = WatchUi.loadResource(Rez.Drawables.Phase00);
        self.images[Rez.Drawables.Phase17] = WatchUi.loadResource(Rez.Drawables.Phase17);
        self.images[Rez.Drawables.Phase26] = WatchUi.loadResource(Rez.Drawables.Phase26);
        self.images[Rez.Drawables.Phase35] = WatchUi.loadResource(Rez.Drawables.Phase35);
        self.images[Rez.Drawables.Phase44] = WatchUi.loadResource(Rez.Drawables.Phase44);
        self.images[Rez.Drawables.Phase53] = WatchUi.loadResource(Rez.Drawables.Phase53);
        self.images[Rez.Drawables.Phase62] = WatchUi.loadResource(Rez.Drawables.Phase62);
        self.images[Rez.Drawables.Phase71] = WatchUi.loadResource(Rez.Drawables.Phase71);
    }

    function update(deltaTime as Long) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        var today = Gregorian.utcInfo(Time.now(), Time.FORMAT_SHORT);
		var p = self.api.getPhase(today.year, today.month, today.day, today.hour, today.min, today.sec);
		var south = false;
        if (self.myInfo != null) {
            south = (self.myInfo.accuracy != null &&
                myInfo.accuracy > Position.QUALITY_NOT_AVAILABLE &&
                myInfo.position != null &&
                myInfo.position.toDegrees()[0] < 0
            );
        }

		var desc = self.api.phaseDescription(south, p["phase"]);
		var illum = (p["illuminated"] * 100).format("%.1f") + "%";
		if (illum.equals("100.0%")) {
            illum = "100%";
        }
		var days = (p["age"].format("%.1f"));
		self.moon.age = days + " days";
        self.moon.description = desc[0];
        self.moon.image = desc[1];
    }

    function render(dc, context) {
        var bitmap = self.images[self.moon.image];
       	dc.drawBitmap(self.moon.position[0], self.moon.position[1], bitmap);
        dc.setColor(self.moon.color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(self.moon.position[0] + 24, self.moon.position[1] + 18,
            Graphics.FONT_SYSTEM_XTINY,
            self.moon.description,
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }
}

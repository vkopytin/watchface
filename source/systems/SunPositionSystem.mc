import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Activity;
import Toybox.Sensor;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Position;

class SunPositionSystem {
    static function create(components, api as API_Functions) as SunPositionSystem {
        var inst = new SunPositionSystem(components, api);

        return inst;
    }

    static function isCompatible(entity) as Boolean {
        return entity.hasKey(:sunPosition);
    }

    private const ONE_DAY = new Time.Duration(Time.Gregorian.SECONDS_PER_DAY);
    var api as API_Functions;

    var engine as Engine;
    var sunPosition as SunPositionComponent;

    var chargeAmount;

    var fastUpdate = (5 * 1000) as Long; // keep fast updates for 5 sec
    var accumulatedTime = 0 as Long;

    function initialize(components, api) {
        self.api = api;
        self.engine = components[:engine] as Engine;
        self.sunPosition = components[:sunPosition] as SunPositionComponent;
    }

    function init() {

    }

    function update(deltaTime as Long) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        var activitInfo = Activity.getActivityInfo();
        if (activitInfo != null && activitInfo.currentLocation != null) {
            self.sunPosition.locationDegrees = activitInfo.currentLocation.toDegrees();
        } else {
            var weather = Toybox.Weather.getCurrentConditions();
            if (weather != null) {
                var location = weather.observationLocationPosition;
                if (location != null) {
                    self.sunPosition.locationDegrees = location.toDegrees();
                }
            }
        }
        var today = Time.today();
        var now = Time.now();
        var lat = self.sunPosition.locationDegrees[0];
		var lng = self.sunPosition.locationDegrees[1];
        var timesToday = self.api.calculate(today, new Position.Location({
            :latitude => lat,
            :longitude => lng,
            :format => :degrees
        }).toRadians(), SUNSET);
        var timesTomorrow = self.api.calculate(today.add(ONE_DAY), new Position.Location({
            :latitude => lat,
            :longitude => lng,
            :format => :degrees
        }).toRadians(), SUNRISE);
        var sunSetInfo = Gregorian.info(timesToday, Time.FORMAT_MEDIUM);
        var sunRiseInfo = Gregorian.info(timesTomorrow, Time.FORMAT_MEDIUM);
        self.sunPosition.sunset = sunSetInfo.hour + ":" + sunSetInfo.min.format("%02d");
        self.sunPosition.sunrise = sunRiseInfo.hour + ":" + sunRiseInfo.min.format("%02d");
    }

    function render(dc, context) {
        dc.setColor(self.sunPosition.color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            self.sunPosition.position[0], self.sunPosition.position[1],
            Graphics.FONT_SYSTEM_XTINY,
            self.sunPosition.sunset,
            Graphics.TEXT_JUSTIFY_CENTER
        );
        dc.drawText(
            self.sunPosition.position[0] + 90, self.sunPosition.position[1],
            Graphics.FONT_SYSTEM_XTINY,
            self.sunPosition.sunrise,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }
}

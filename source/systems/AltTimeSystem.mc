import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;

class AltTimeSystem {
    static function setup(systems, entity, api) {
        if (entity.hasKey(:altTime) and entity.hasKey(:time)) {
            systems.add(new AltTimeSystem(entity, api));
        }
    }

    var api as API_Functions;
    var engine as Engine;
    var time as TimeComponent;
    var date as DateComponent;
    var altTime as AltTimeComponent;

    var lcdDisplayFont;
    var timezoneDiffDuration;
    var where;

    var fastUpdate = (60 * 1000) as Long; // keep fast updates for minute
    var accumulatedTime = 0 as Long;

    function initialize(components, api as API_Functions) {
        self.api = api;
        self.engine = components[:engine] as Engine;
        self.time = components[:time] as TimeComponent;
        self.date = components[:date] as DateComponent;
        self.altTime = components[:altTime] as AltTimeComponent;
    }

    function init() {
        self.lcdDisplayFont = WatchUi.loadResource(Rez.Fonts.lcdDisplay12);
        self.where = new Position.Location({
            :latitude  =>  self.altTime.location[0],
            :longitude => self.altTime.location[1],
            :format    => :degrees,
        });

        var timezoneDiffSecs = self.api.getLocationTimeOffset(where);
        self.timezoneDiffDuration = new Time.Duration(timezoneDiffSecs.toNumber());
    }

    function update(deltaTime as Long) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        // Based on today's time offset at this location, calculate the local
        // time, by adding the offset to the current UTC time.
        var epochTimeNow = Time.now();
        //var epochTimeNow = Gregorian.moment({
        //    :year => self.date.year, :month => self.date.month, :day => self.date.day,
        //    :hour => self.time.hours, :minute => self.time.minutes, :second => self.time.seconds
        //});
        var secondaryTimeNow = epochTimeNow.add(self.timezoneDiffDuration);
        var info = Time.Gregorian.utcInfo(secondaryTimeNow, Time.FORMAT_MEDIUM);

        self.altTime.value = self.api.timeFormat(self.altTime.format, info);
    }

    function render(dc, context) {
        context.dc.setColor(self.altTime.color, Graphics.COLOR_TRANSPARENT);
        context.dc.drawText(
            self.altTime.position[0], self.altTime.position[1],
            self.lcdDisplayFont,
            self.altTime.value,
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }
}

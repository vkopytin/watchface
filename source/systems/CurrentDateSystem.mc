import Toybox.Lang;
import Toybox.Math;
import Toybox.Time;
import Toybox.Graphics;

function currentDateSystemCreate(components) as CurrentDateSystem {
    var inst = new CurrentDateSystem(components);

    return inst;
}

function currentDateSystemIsCompatible(entity) as Boolean {
    return entity.hasKey(:date);
}

class CurrentDateSystem {
    var engine as Engine;
    var date as DateComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (60 * 1000) as Long; // keep fast updates for min
    var accumulatedTime = self.fastUpdate + 1 as Long;

    function initialize(components) {
        self.engine = components[:engine];
        self.date = components[:date];
        self.stats = components[:stats];
    }

    function init() {
        
    }

    function update(deltaTime as Long) {
        self.accumulatedTime += deltaTime;
        if (self.accumulatedTime < self.fastUpdate) {
            return;
        }

        self.accumulatedTime = 0;

        var info = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
        self.date.dayOfWeek = info.day_of_week;
        self.date.month = info.month;
        self.date.day = info.day;

        var screenCenterPoint = self.engine.centerPoint;
        var moveMatrix = [screenCenterPoint];
        self.date.point = add([self.date.position], moveMatrix)[0];
    }

    function render(dc, context) {
        var dateStr = Lang.format("$1$, $3$", [
            self.date.dayOfWeek, self.date.month, self.date.day
        ]);

        var point = self.date.point;

        dc.setColor(self.date.color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(point[0], point[1], Graphics.FONT_SYSTEM_XTINY, dateStr, Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class UpdateCurrentDate {
function exec(entity, components) {
    var context = components[:context];
    var date = components[:date];
    var titles = components[:titles];

    date.accumulatedTime -= context.deltaTime;
    if (date.accumulatedTime > 0) {
        return;
    }

    date.accumulatedTime = date.fastUpdate;

    var info = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
    date.dayOfWeek = info.day_of_week;
    date.month = info.month;
    date.day = info.day;

    var screenCenterPoint = context.centerPoint;
    var moveMatrix = [screenCenterPoint];
    date.point = add([date.position], moveMatrix)[0];
    var dateStr = Lang.format("$1$, $3$", [
        date.dayOfWeek, date.month, date.day
    ]);

    titles.color = date.color;
    titles.titles = [
        [date.point[0], date.point[1], Graphics.FONT_SYSTEM_XTINY, dateStr, Graphics.TEXT_JUSTIFY_CENTER]
    ];
}
}

function makeUpdateCurrentDateDelegate() {
    return new UpdateCurrentDate();
}

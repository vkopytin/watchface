import Toybox.Lang;
import Toybox.Math;

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

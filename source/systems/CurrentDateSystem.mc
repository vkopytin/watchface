import Toybox.Lang;
import Toybox.Math;

class CurrentDateSystem {
    function setup(systems, entity, api) {
        if (entity.hasKey(:date)) {
            systems.add(new CurrentDateSystem(entity));
        }
    }

    var engine as Engine;
    var date as DateComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (60 * 1000) as Long; // keep fast updates for min
    var accumulatedTime = 0 as Long;

    function initialize(components) {
        self.engine = components[:engine];
        self.date = components[:date];
        self.stats = components[:stats];
    }

    function init() {
        
    }

    function update(deltaTime as Long) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        var info = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
        self.date.dayOfWeek = info.day_of_week;
        self.date.year = info.year;
        self.date.month = info.month;
        self.date.day = info.day;

        self.date.strValue = Lang.format("$1$, $3$", [
            self.date.dayOfWeek, self.date.month, self.date.day
        ]);
    }

    function render(dc, context) {
        context.dc.setColor(self.date.color, Graphics.COLOR_TRANSPARENT);
        context.dc.drawText(self.date.position[0], self.date.position[1], Graphics.FONT_SYSTEM_XTINY, self.date.strValue, Graphics.TEXT_JUSTIFY_CENTER);
    }
}

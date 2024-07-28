import Toybox.Lang;

class DigitalTimeSystem {
    static function create(components) as DigitalTimeSystem {
        var inst = new DigitalTimeSystem(components);

        return inst;
    }

    static function isCompatible(entity) {
        return entity.hasKey(:time) and entity.hasKey(:digitalTime);
    }

    var components;
    var engine;
    var time as TimeComponent;
    var digitalTime as DigitalTimeComponent;
    var lcdDisplayFont;

    var fastUpdate = 1000 as Long; // keep fast updates for minute
    var accumulatedTime = 0 as Long;

    function initialize(components) {
        self.components = components;
        self.engine = components[:engine];
        self.time = components[:time];
        self.digitalTime = components[:digitalTime];
    }

    function init() {
        self.lcdDisplayFont = WatchUi.loadResource(Rez.Fonts.lcdDisplay24);
        //self.lcdDisplayFont = Graphics.FONT_LARGE;
    }

    function update(deltaTime) {
        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        if (self.time.secondsNumber % 2 == 0) {
            self.digitalTime.timeTitle = self.time.hours.format("%02d") + " " + self.time.minutes.format("%02d");
        } else {
            self.digitalTime.timeTitle = self.time.hours.format("%02d") + ":" + self.time.minutes.format("%02d");
        }
    }

    function render(dc, context) {
        context.dc.setColor(self.digitalTime.color, Graphics.COLOR_TRANSPARENT);
        context.dc.drawText(
            self.digitalTime.position[0], self.digitalTime.position[1],
            self.lcdDisplayFont, self.digitalTime.timeTitle,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        //self.engine.clipArea[0][0] = self.digitalTime.position[0] + 13;
        //self.engine.clipArea[0][1] = self.digitalTime.position[1] + 1;
        //self.engine.clipArea[1][0] = 31;
        //self.engine.clipArea[1][1] = 16;
    }
}

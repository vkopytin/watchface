using Toybox.Lang;

class RenderDigitalTimeSystem {
    static function create(components) as RenderDigitalTimeSystem {
        var inst = new RenderDigitalTimeSystem(components);

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

    function initialize(components) {
        self.components = components;
        self.engine = components[:engine];
        self.time = components[:time];
        self.digitalTime = components[:digitalTime];
    }

    function init() {
        self.lcdDisplayFont = WatchUi.loadResource(Rez.Fonts.lcdDisplay);
    }

    function update(deltaTime) {
        self.digitalTime.timeTitle = Lang.format("$1$:$2$:$3$", [
            self.time.hours.format("%02d"),
            self.time.minutes.format("%02d"),
            self.time.seconds.format("%02d")
        ]);
    }
    
    function render(dc, context) {
        dc.setColor(self.digitalTime.color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            self.digitalTime.position[0], self.digitalTime.position[1],
            self.lcdDisplayFont, self.digitalTime.timeTitle,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        self.engine.clipArea[0][0] = 105;
        self.engine.clipArea[0][1] = 141;
        self.engine.clipArea[1][0] = 31;
        self.engine.clipArea[1][1] = 16;
    }
}

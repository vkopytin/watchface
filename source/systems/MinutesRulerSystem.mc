import Toybox.Math;
import Toybox.Lang;

class MinutesRulerSystem {
    static function create(components) as MinutesRulerSystem {
        return new MinutesRulerSystem(components);
    }

    static function isCompatible(entity) {
        return entity.hasKey(:time) and entity.hasKey(:minutesRuler);
    }

    var components;
    var engine;
    var time;
    var ruler;
    var minutesOncesRuler;
    var minutesDescRuler;

    var fastUpdate = 5 * 1000 as Long; // skip updates for 5 secs
    var accumulatedTime = 0 as Long;

    var pid = Controller.create(0.03, 0.1, 0.1, 0.05);
    var pidDec = Controller.create(0.03, 0.1, 0.1, 0.05);

    function initialize(components) {
        self.components = components;
        self.engine = components[:engine];
        self.time = components[:time];
        self.ruler = components[:minutesRuler];
    }

    function init() {
        self.minutesOncesRuler = WatchUi.loadResource(Rez.Drawables.minutesOncesRuler);
        self.minutesDescRuler = WatchUi.loadResource(Rez.Drawables.minutesDescRuler);
    }

    function modulus(value) {
        if (value > 50) {
            return value - 50;
        } else if (value > 40) {
            return value - 40;
        } else if (value > 30) {
            return value - 30;
        } else if (value > 20) {
            return value - 20;
        } else if (value > 10) {
            return value - 10;
        } else {
            return value;
        }
    }

    function update(deltaTime) {
        self.ruler.lastStep = self.pid.update(self.ruler.lastStep);
        self.ruler.lastDecStep = self.pidDec.update(self.ruler.lastDecStep);

        self.ruler.deltaIndex = 5 - self.ruler.lastStep * 48.9;
        self.ruler.deltaDecIndex = -110 - self.ruler.lastDecStep * 7.1;

        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;

        var minutes = self.time.minutes;

        var minutesOnce = minutes.toNumber() % 10;
        self.pid.setTarget(minutesOnce);
        if (minutesOnce < self.ruler.lastStep) {
            self.pid.reset();
            self.ruler.lastStep = minutesOnce - 2;
        } else {
            self.ruler.lastStep = minutesOnce;
        }

        var minutesDec = Math.floor(minutes / 10) * 10;
        self.pidDec.setTarget(minutesDec);
        if (minutesDec < self.ruler.lastDecStep) {
            self.pidDec.reset();
            self.ruler.lastDecStep = minutesDec - 2;
        } else {
            self.ruler.lastDecStep = minutesDec;
        }
    }

    function render(dc, context) {

    }
}

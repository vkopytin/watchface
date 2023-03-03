import Toybox.Math;
import Toybox.Lang;

class SecondsRulerSystem {
    static function create(components) as SecondsRulerSystem {
        return new SecondsRulerSystem(components);
    }

    static function isCompatible(entity) {
        return entity.hasKey(:time) and entity.hasKey(:ruler);
    }

    var components;
    var engine;
    var time;
    var ruler;
    var rulerRes;
    var pid = Controller.create(0.03, 0.1, 0.1);

    var fastUpdate = 1000 as Long; // skip updates for 5 secs
    var accumulatedTime = 0 as Long;

    function initialize(components) {
        self.components = components;
        self.engine = components[:engine];
        self.time = components[:time];
        self.ruler = components[:ruler];
    }

    function init() {
        self.rulerRes = WatchUi.loadResource(Rez.Drawables.ruler);
    }

    function update(deltaTime) {
        var scale = Math.PI * 10;
        self.ruler.lastStep = self.pid.update(self.ruler.lastStep);
        self.ruler.deltaIndex = -195 - self.ruler.lastStep * scale;

        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }
        self.accumulatedTime = self.fastUpdate;

        self.pid.setTarget(self.time.seconds);
        if (self.time.seconds < self.ruler.lastStep) {
            self.pid.reset();
            self.ruler.lastStep = self.time.seconds - 2.0;
        } else {
            self.ruler.lastStep = self.time.seconds;
        }
    }
}

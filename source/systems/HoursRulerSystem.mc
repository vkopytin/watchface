import Toybox.Math;
import Toybox.Lang;

class HoursRulerSystem {
    static function create(components) as HoursRulerSystem {
        return new HoursRulerSystem(components);
    }

    static function isCompatible(entity) {
        return entity.hasKey(:time) and entity.hasKey(:hoursRuler);
    }

    var components;
    var engine;
    var time;
    var ruler;
    var rulerRes;

    var fastUpdate = 10 * 1000 as Long; // skip updates for 5 secs
    var accumulatedTime = 0 as Long;

    var pid = Controller.create(0.03, 0.1, 0.1);

    function initialize(components) {
        self.components = components;
        self.engine = components[:engine];
        self.time = components[:time];
        self.ruler = components[:hoursRuler];
    }

    function init() {
        self.rulerRes = WatchUi.loadResource(Rez.Drawables.hoursRuler);
    }

    function update(deltaTime) {
        self.ruler.lastStep = self.pid.update(self.ruler.lastStep);

        self.ruler.deltaIndex = 16 -self.ruler.lastStep * 35.45;

        self.accumulatedTime -= deltaTime;
        if (self.accumulatedTime > 0) {
            return;
        }

        self.accumulatedTime = self.fastUpdate;
        
        var hours = Math.floor(self.time.hours);
        self.pid.setTarget(hours);
        if (hours < self.ruler.lastStep) {
            self.pid.reset();
        }
        self.ruler.lastStep = hours;
    }
}

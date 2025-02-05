import Toybox.Lang;
import Toybox.Math;

function currentTimeSystemCreate(components) as CurrentTimeSystem {
    var inst = new CurrentTimeSystem(components);

    return inst;
}

function currentTymeSystemIsCompatible(entity) as Boolean {
    return entity.hasKey(:time) and entity.hasKey(:oneTime);
}

function remainder(a as Float, b as Float) as Float {
    // Handling negative values
    if (a < 0) {
        a = -a;
    }
    if (b < 0) {
        b = -b;
    }
    
    // Finding mod by repeated subtraction
    var mod = a;
    while (mod >= b) {
        mod = mod - b;
    }
    
    // Sign of result typically depends
    // on sign of a.
    if (a < 0) {
        return -mod;
    }
    
    return mod;
}

class CurrentTimeSystem {
    var components;
    var engine as Engine;
    var time as TimeComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (5 * 1000) as Long; // keep fast updates for 5 secs
    var accumulatedTime = 0 as Long;

    function initialize(components) {
        self.components = components;
        self.engine = components[:engine];
        self.time = components[:time];
        self.stats = components[:stats];
    }

    function init() {
        
    }

    function update(deltaTime as Long) {
        var delta = deltaTime.toFloat() / 1000.0;
        self.accumulatedTime -= deltaTime;
        self.time.secondsNumber = (self.time.seconds + delta).toNumber();
        if (self.accumulatedTime > 0) {
            if (self.time.secondsNumber > 59) {
                self.time.secondsNumber = 0;
            }

            self.time.seconds = self.time.seconds + delta;
            self.time.minutes = self.time.minutes + delta / 60.0;
            self.time.hours = (self.time.hours + delta / 60.0 / 60.0);

            return;
        }
        self.accumulatedTime = self.fastUpdate;

        var clockTime = System.getClockTime();

        self.time.hours = clockTime.hour.toFloat();
        self.time.minutes = clockTime.min.toFloat();
        self.time.secondsNumber = clockTime.sec;
        self.time.seconds = clockTime.sec.toFloat();
    }
}

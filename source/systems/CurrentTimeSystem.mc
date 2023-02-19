import Toybox.Lang;
import Toybox.Math;

function currentTimeSystemCreate(components) as CurrentTimeSystem {
    var inst = new CurrentTimeSystem(components);

    return inst;
}

function currentTymeSystemIsCompatible(entity) as Boolean {
    return entity.hasKey(:time);
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
    var engine as Engine;
    var time as TimeComponent;
    var stats as PerformanceStatisticsComponent;

    var fastUpdate = (5 * 1000) as Long; // keep fast updates for 5 secs
    var accumulatedTime = self.fastUpdate + 1 as Long;

    function initialize(components) {
        self.engine = components[:engine];
        self.time = components[:time];
        self.stats = components[:stats];
    }

    function init() {
        
    }

    function update(deltaTime as Long) {
        self.accumulatedTime += deltaTime;
        if (self.accumulatedTime < self.fastUpdate) {
            var delta = deltaTime.toFloat() / 1000.0;
            self.time.seconds = self.time.seconds + delta;
            self.time.minutes = self.time.minutes + delta / 60.0;
            self.time.hours = (self.time.hours + delta / 60.0 / 60.0);
            self.engine.timeSec = self.time.seconds;

            return;
        }

        self.accumulatedTime = 0;
        self.accumulatedTime = 0;
        var clockTime = System.getClockTime();

        self.time.hours = 1.0 * clockTime.hour;
        self.time.minutes = 1.0 * clockTime.min;
        self.time.seconds = 1.0 * clockTime.sec;
        self.engine.timeSec = self.time.seconds;
    }

    function render(dc, context) {

    }
}

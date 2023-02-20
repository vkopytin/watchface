import Toybox.Math;
import Toybox.Lang;

function randomId(prefix) as String {
    return prefix + "-" + Math.floor(Math.rand() * 1000);
}

function makeEngineTiming(engine as EngineV2) as EngineTiming {
    var inst = new EngineTiming(engine);

    return inst;
}

class EngineTimingSummary {
    var ticks = 0;
    var start = 0;
    var total = 0;
    var delta = 0;
    var now = 0;
}

class EngineTiming {
    var time = new EngineTimingSummary();
    var entity as EngineEntity;
    var system as EngineSystem;
    var componentName as String;

    function initialize(engine as EngineV2) {
        var entityName = randomId("clock");
        self.componentName = randomId("time");
        var systemName = randomId("timer");

        self.reset();

        self.entity = engine.makeEntity(entityName);

        // Associate the time component to the clock entity.
        self.entity.setComponent(self.componentName, self.time);

        // A system for updating the time component
        self.system = engine.makeSystem(systemName, [self.componentName], self);
    }

    function exec(entity, components) {
        var time = components[self.componentName];
        var now = System.getTimer();

        // Update ticks counter
        time.ticks += 1;

        // Init start time
        if (time.start == 0) {
            time.start = now;
        }

        // Update total time
        time.total = now - time.start;

        // Update delta
        if (time.now > 0) {
            time.delta = now - time.now;
        }

        // Update now time
        time.now = now;
    }

    function reset() {
        self.time.ticks = 0; // Number of ticks (frames)
        self.time.start = 0; // initial time
        self.time.now = 0; // Current absolute time
        self.time.total = 0; // total execution time
        self.time.delta = 0; // delta time from prev tick
    }

    function getTime() {
        return self.time;
    }

    function getEntity() {
        return self.entity;
    }

    function getSystem() {
        return self.system;
    }
}

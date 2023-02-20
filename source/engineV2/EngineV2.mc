import Toybox.System;
import Toybox.Lang;

function makeEngineV2() as EngineV2 {
    var inst = new EngineV2();
    return inst;
}

class EngineV2 extends EventEmitter {
    var entities = {};
    var systems = [];
    var systemVsEntities = {};
    var systemsToExec = [];
    var systemsToExecLength = 0;

    var lastTime = System.getTimer();
    var averageTickMs = 0;

    function initialize() {
        EventEmitter.initialize();
    }

    function makeEntity(name as String) as EngineEntity {
        if (self.entities.hasKey(name)) {
            throw new EngineException("entity with the name [" + name + "] already exists");
        }
        var entity = new EngineEntity(name);
        EventEmitter.on("component:add", method(:updateSystemsVsEntities));
        EventEmitter.on("component:delete", method(:updateSystemsVsEntities));
        EventEmitter.on("entity:remove", method(:removeEntity));

        self.entities[name] = entity;

        return entity;
    }

    function getEntity(name as String) {
        return self.entities[name];
    }

    function removeEntity(name as String) {
        self.entities.remove(name);

        self.updateSystemsVsEntities();
    }

    function makeSystem(name as String, components as Array<String>, handler) as EngineSystem {
        // Systems is an array instead of a map to guarantee execution order
        var length = self.systems.size();
        for (var index = 0; index < length; index++) {
            var system = self.systems[index];
            if (system.name == name) {
                throw new EngineException("System [" + name + "] already exists");
            }
        }

        var system = new EngineSystem(name, components, handler);
        EventEmitter.on("system:remove", method(:removeSystem));
        self.systems.add(system);

        self.updateSystemsVsEntities();

        return system;
    }

    function getSystem(name as String) as EngineSystem or Null {
        var length = self.systems.size();
        for (var index = 0; index < length; index++) {
            var system = self.systems[index];
            if (system.name == name) {
                return system;
            }
        }

        return null;
    }

    function removeSystem(name as String) as EngineSystem or Null {
        var length = self.systems.size();
        for (var index = 0; index < length; index++) {
            var system = self.systems[index];
            if (system.name == name) {
                self.systems.remove(system);
                self.updateSystemsVsEntities();

                return system;
            }
        }
        return null;
    }

    function updateSystemsVsEntities() as Void {
        var length = self.systems.size();
        for (var index = 0; index < length; index++) {
            var system = self.systems[index];
            var systemName = system.name;
            var compatibleEntities = [];
            self.systemVsEntities[systemName] = compatibleEntities;

            var entities = self.entities.values();
            var entitiesLength = self.entities.size();
            for (var idx = 0; idx < entitiesLength; idx++) {
                var entity = entities[idx];
                if (system.isCompatibleEntity(entity)) {
                    compatibleEntities.add(entity);
                }
            }
        }
    }

    function preTick() {
        var length = self.systems.size();
        var result = [];
        for (var index = 0; index < length; index++) {
            var system = self.systems[index];

            var systemVsEntitiesLength = self.systemVsEntities[system.name].size();
            for (var idx = 0; idx < systemVsEntitiesLength; idx++) {
                var entity = self.systemVsEntities[system.name][idx];

                var components = {};
                var componentsLength = system.components.size();
                for (var i = 0; i < componentsLength; i++) {
                    var name = system.components[i];
                    components[name] = entity.components[name];
                }
                result.add([system, entity, components]);
            }
        }
        self.systemsToExec = result;

        self.systemsToExecLength = self.systemsToExec.size();
    }

    function tick() as Void {
        var currentTime = System.getTimer();
        var deltaTime = currentTime - self.lastTime;
        self.lastTime = currentTime;
        EventEmitter.emit("tick:before", self);

        var length = self.systemsToExecLength;
        var index = 0;
        var n = length % 8;

        if (n > 0) {
            do {
                var toExec = self.systemsToExec[index];
                toExec[2][:deltaTime] = deltaTime;
                toExec[0].handler.exec(toExec[1], toExec[2]);
                index += 1;
                n -= 1;
            }
            while (n > 0); // n must be greater than 0 here
        }

        n = Math.floor(length / 8);
        if (n > 0) { // if iterations < 8 an infinite loop, added for safety in second printing
            do {
                var toExec = self.systemsToExec[index];
                toExec[2][:deltaTime] = deltaTime;
                toExec[0].handler.exec(toExec[1], toExec[2]);
                index += 1;
                toExec = self.systemsToExec[index];
                toExec[2][:deltaTime] = deltaTime;
                toExec[0].handler.exec(toExec[1], toExec[2]);
                index += 1;
                toExec = self.systemsToExec[index];
                toExec[2][:deltaTime] = deltaTime;
                toExec[0].handler.exec(toExec[1], toExec[2]);
                index += 1;
                toExec = self.systemsToExec[index];
                toExec[2][:deltaTime] = deltaTime;
                toExec[0].handler.exec(toExec[1], toExec[2]);
                index += 1;
                toExec = self.systemsToExec[index];
                toExec[2][:deltaTime] = deltaTime;
                toExec[0].handler.exec(toExec[1], toExec[2]);
                index += 1;
                toExec = self.systemsToExec[index];
                toExec[2][:deltaTime] = deltaTime;
                toExec[0].handler.exec(toExec[1], toExec[2]);
                index += 1;
                toExec = self.systemsToExec[index];
                toExec[2][:deltaTime] = deltaTime;
                toExec[0].handler.exec(toExec[1], toExec[2]);
                index += 1;
                toExec = self.systemsToExec[index];
                toExec[2][:deltaTime] = deltaTime;
                toExec[0].handler.exec(toExec[1], toExec[2]);
                index += 1;
                n -= 1;
            }
            while (n > 0); // n must be greater than 0 here also
        }

        EventEmitter.emit("tick:after", self);
        var delta = System.getTimer() - self.lastTime;
        self.averageTickMs = (self.averageTickMs + delta) / 2;
    }
}

class EngineException extends Lang.Exception {
    function initialize(msg) {
        Exception.initialize();
        self.mMessage = msg;
    }
}

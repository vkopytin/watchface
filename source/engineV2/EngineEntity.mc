import Toybox.Lang;

class EngineEntity extends EventEmitter {
    var name = "";
    var components = {};

    function initialize(name as String) {
        EventEmitter.initialize();

        self.name = name;
    }

    function getName() as String {
        return self.name;
    }

    function hasComponent(componentName as String) {
        return self.components.hasKey(componentName);
    }

    function setComponent(componentName as String, componentData) {
        var newComponent = false;
        if (self.components.hasKey(componentName)) {
            newComponent = true;
        }

        self.components[componentName] = componentData;
        if (newComponent) {
            EventEmitter.emit("component:add", newComponent);
        }
    }

    function getComponent(componentName as String) {
        return self.components[componentName];
    }

    function deleteComponent(componentName as String) {
        if (self.hasComponent(componentName)) {
            self.components.remove(componentName);

            EventEmitter.emit("component:remove", componentName);
        }
    }

    function destroy() {
        EventEmitter.emit("entity:remove", self.name);
    }
}

import Toybox.Lang;

class EngineSystem extends EventEmitter {
    var name = "";
    var components = [];
    var handler as Method;

    function initialize(name as String, components as Array<String>, handler as Method) {
        EventEmitter.initialize();

        self.name = name;
        self.components = components;
        self.handler = handler;
    }

    function isCompatibleEntity(entity as EngineEntity) as Boolean {
        var length = self.components.size();
        for (var index = 0; index < length; index++) {
            if (!entity.hasComponent(self.components[index])) {
                return false;
            }
        }
        return true;
    }

    function getName() as String {
        return self.name;
    }

    function destroy() {
        EventEmitter.emit("system:remove", self.name);
    }
}

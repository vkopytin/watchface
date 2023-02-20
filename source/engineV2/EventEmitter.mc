import Toybox.Lang;
import Toybox.System;

class EventEmitter {
    var subscribers = {};

    function on(name as String, handler) {
        if (!self.subscribers.hasKey(name)) {
            self.subscribers[name] = [];
        }
        self.subscribers[name].add(handler);
    }

    function off(name, handler) {
        if (!self.subscribers.hasKey(name)) {
            return;
        }

        var subscribers = self.subscribers[name];
        subscribers.remove(handler);
    }

    function emit(event as String, arg) {
        if (!self.subscribers.hasKey(event)) {
            return;
        }

        var subscribers = self.subscribers[event];
        subscribers = subscribers.slice();
        var i = subscribers.length;

        while (i > 0) {
            i -= 1;
            try {
                subscribers[i].invoke(arg);
            } catch (e) {
                System.print(e.getErrorMessage());
            }
        }
    }
}

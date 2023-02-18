import Toybox.System;
import Toybox.Timer;

function mainTimerCreate(updateCallback) {
    var inst = new MainTimer(updateCallback);

    return inst;
}

class MainTimer {
    var timer as Timer.Timer;
    var deltaTime = 1.0 / 60.0;
    var lastTime = System.getTimer();
    var accumulatedTime = 0.0;

    var updateCallback;

    function initialize(updateCallback) {
        self.updateCallback = updateCallback;
        self.timer = new Timer.Timer();
    }

    function nextTick() {
        var time = System.getTimer();
        self.accumulatedTime += (time - self.lastTime) / 1000.0;

        if (self.accumulatedTime > 1) {
            self.accumulatedTime = 1;
        }

        while (self.accumulatedTime > self.deltaTime) {
            self.updateCallback.invoke(self.deltaTime);
            self.accumulatedTime -= self.deltaTime;
        }

        self.lastTime = time;
    }

    function start() as Void {
        self.enqueue();
    }

    function stop() {

    }

    private function enqueue() as Void {
        self.timer.start(method(:update), 100, false);
    }

    function update() as Void {
        self.nextTick();
        self.enqueue();
    }
}

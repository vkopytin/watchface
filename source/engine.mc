import Toybox.System;
import Toybox.Math;
import Toybox.Lang;

function EngineCreate() {
    var inst = new Engine();

    return inst;
}

function makeSystemsFromEntites(entities) {
    var systems = [];
    var length = entities.size();

    for (var index = 0; index < length; index++) {
        var entity = entities[index];
        if (currentTymeSystemIsCompatible(entity)) {
            var system = currentTimeSystemCreate(entity);
            systems.add(system);
        }
        if (weatherIconRenderSystemIsCompatible(entity)) {
            var system = weatherIconRenderSystemCreate(entity);
            systems.add(system);
        }
        if (currentDateSystemIsCompatible(entity)) {
            var system = currentDateSystemCreate(entity);
            systems.add(system);
        }
        if (stressSensorSystemIsCompatible(entity)) {
            var system = stressSensorSystemCreate(entity);
            systems.add(system);
        }
        if (barometerSensorSystemIsCompatible(entity)) {
            var system = barometerSensorSystemCreate(entity);
            systems.add(system);
        }
        if (compassSensorSystemIsCompatible(entity)) {
            var system = compassSensorSystemCreate(entity);
            systems.add(system);
        }
        if (minuteTicksSystemIsCompatible(entity)) {
            var system = minuteTicksSystemCreate(entity);
            systems.add(system);
        }
        if (hourTicksSystemIsCompatible(entity)) {
            var system = hourTicksSystemCreate(entity);
            systems.add(system);
        }
        if (hoursHandSystemIsCompatible(entity)) {
            var system = hoursHandSystemCreate(entity);
            systems.add(system);
        }
        if (minutesHandSystemIsCompatible(entity)) {
            var system = minutesHandSystemCreate(entity);
            systems.add(system);
        }
        if (secondsHandSystemIsCompatible(entity)) {
            var system = secondsHandSystemCreate(entity);
            systems.add(system);
        }
        if (polygonRenderSystemCreateIsCompatible(entity)) {
            var system = polygonRenderSystemCreate(entity);
            systems.add(system);
        }
        if (multilineRenderSystemIsCompatible(entity)) {
            var system = multilineRenderSystemCreate(entity);
            systems.add(system);
        }
    }

    return systems;
}

class Engine {
    var width = 240;
    var height = 240;
    var centerPoint = [120, 120];
    var lastTime = System.getTimer();
    var systemsLength = 0;
    var timeSec = 0;
    var clipArea = [[100,100],[200,200]];
    var averageTickMs = 0;
    var averageRenderMs = 0;

    var entities = [{
        :name => "minute ticks",
        :engine => self,
        :stats => performanceStatisticsComponentCreate(),
        :polygon => shapeComponentCreate(),
        :minuteTicks => minuteTicksCreate(),
    }, {
        :name => "hour ticks",
        :engine => self,
        :stats => performanceStatisticsComponentCreate(),
        :polygon => shapeComponentCreate(),
        :hourTicks => hourTicksCreate(),
    }, {
        :name => "hour hand",
        :engine => self,
        :stats => performanceStatisticsComponentCreate(),
        :time => timeComponentCreate(),
        :hoursHand => hoursHandComponentCreate(),
        :polygon => shapeComponentCreate(),
        :multiline => {},
    }, {
        :name => "minute hand",
        :engine => self,
        :stats => performanceStatisticsComponentCreate(),
        :time => timeComponentCreate(),
        :minutesHand => minutesHandComponentCreate(),
        :polygon => shapeComponentCreate(),
        :multiline => {},
    }, {
        :name => "weather",
        :engine => self,
        :stats => performanceStatisticsComponentCreate(),
        :weather => weatherComponentCreate(),
    }, {
        :name => "current date",
        :engine => self,
        :stats => performanceStatisticsComponentCreate(),
        :date => dateComponentCreate(),
    }, {
        :name => "stress",
        :engine => self,
        :stats => performanceStatisticsComponentCreate(),
        :stress => stressSensorComponentCreate(),
    }, {
        :name => "barometer",
        :engine => self,
        :stats => performanceStatisticsComponentCreate(),
        :barometer => barometerSensorComponentCreate(),
    }, {
        :name => "compass",
        :engine => self,
        :stats => performanceStatisticsComponentCreate(),
        :compass => compassSensorComponentCreate(),
    }, {
        :name => "seconds hand",
        :engine => self,
        :stats => performanceStatisticsComponentCreate(),
        :time => timeComponentCreate(),
        :secondsHand => secondsHandComponentCreate(),
        :polygon => shapeComponentCreate(),
    }];

    var systems = makeSystemsFromEntites(entities);

    function init(width, height) {
        self.width = width;
        self.height = height;
        self.centerPoint = [width / 2, height / 2];
        self.systemsLength = self.systems.size();
        for (var index = 0; index < self.systemsLength; index += 1) {
            var current = systems[index];
            current.init();
        }
    }

    function tick() {
        var currentTime = System.getTimer();
        var deltaTime = currentTime - self.lastTime;
        self.lastTime = currentTime;
        var length = self.systemsLength;
        var index = 0;
        var n = length % 8;

        if (n > 0) {
            do {
                var current = systems[index];
                current.update(deltaTime);
                index += 1;
                n -= 1;
            }
            while (n > 0); // n must be greater than 0 here
        }

        n = Math.floor(length / 8);
        if (n > 0) { // if iterations < 8 an infinite loop, added for safety in second printing
            do {
                var current = systems[index];
                current.update(deltaTime);
                index += 1;
                current = systems[index];
                current.update(deltaTime);
                index += 1;
                current = systems[index];
                current.update(deltaTime);
                index += 1;
                current = systems[index];
                current.update(deltaTime);
                index += 1;
                current = systems[index];
                current.update(deltaTime);
                index += 1;
                current = systems[index];
                current.update(deltaTime);
                index += 1;
                current = systems[index];
                current.update(deltaTime);
                index += 1;
                current = systems[index];
                current.update(deltaTime);
                index += 1;
                n -= 1;
            }
            while (n > 0); // n must be greater than 0 here also
        }

        var delta = System.getTimer() - self.lastTime;
        self.averageTickMs = (self.averageTickMs + delta) / 2;
    }

    function render(dc) {
        var currentTime = System.getTimer();
        var length = self.systemsLength;
        var context = renderContextCreate();
        var index = 0;
        var n = length % 8;

        if (n > 0) {
            do {
                var current = systems[index];
                current.render(dc, context);
                index += 1;
                n -= 1;
            }
            while (n > 0); // n must be greater than 0 here
        }

        n = Math.floor(length / 8);
        if (n > 0) { // if iterations < 8 an infinite loop, added for safety in second printing
            do {
                var current = systems[index];
                current.render(dc, context);
                index += 1;
                current = systems[index];
                current.render(dc, context);
                index += 1;
                current = systems[index];
                current.render(dc, context);
                index += 1;
                current = systems[index];
                current.render(dc, context);
                index += 1;
                current = systems[index];
                current.render(dc, context);
                index += 1;
                current = systems[index];
                current.render(dc, context);
                index += 1;
                current = systems[index];
                current.render(dc, context);
                index += 1;
                current = systems[index];
                current.render(dc, context);
                index += 1;
                n -= 1;
            }
            while (n > 0); // n must be greater than 0 here also
        }

        var handWidth = 10;
        var borderColor=Graphics.COLOR_BLACK;
        var arborColor=Graphics.COLOR_LT_GRAY;
        var offsetInnerCircle = 1;
		var offsetOuterCircle = -1;

        dc.setColor(borderColor,Graphics.COLOR_BLACK);
		dc.fillCircle(self.width / 2, self.height / 2, handWidth*0.65-offsetOuterCircle); // *0.65
		dc.setColor(arborColor, Graphics.COLOR_WHITE);
		dc.fillCircle(self.width / 2, self.height / 2, handWidth*0.65-offsetInnerCircle); // -4

        var delta = System.getTimer() - self.lastTime;
        self.averageRenderMs = (self.averageRenderMs + delta) / 2;
    }
}

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

    /*systems.add(minuteTicksSystemCreate(entities[0]));
    systems.add(hourTicksSystemCreate(entities[1]));
    systems.add(weatherIconRenderSystemCreate(entities[2]));
    systems.add(currentTimeSystemCreate(entities[3]));
    systems.add(currentTimeSystemCreate(entities[4]));
    systems.add(currentTimeSystemCreate(entities[5]));
    systems.add(hoursHandSystemCreate(entities[3]));
    systems.add(minutesHandSystemCreate(entities[4]));
    systems.add(secondsHandSystemCreate(entities[5]));
    systems.add(polygonRenderSystemCreate(entities[3]));
    systems.add(multilineRenderSystemCreate(entities[3]));
    systems.add(polygonRenderSystemCreate(entities[4]));
    systems.add(multilineRenderSystemCreate(entities[4]));
    systems.add(polygonRenderSystemCreate(entities[5]));
*/

    for (var index = 0; index < length; index++) {
        var entity = entities[index];
        if (currentTymeSystemIsCompatible(entity)) {
            var system = currentTimeSystemCreate(entity);
            systems.add(system);
        }
        if (SecondsRulerSystem.isCompatible(entity)) {
            var system = SecondsRulerSystem.create(entity);
            systems.add(system);
        }
        if (MinutesRulerSystem.isCompatible(entity)) {
            var system = MinutesRulerSystem.create(entity);
            systems.add(system);
        }
        if (HoursRulerSystem.isCompatible(entity)) {
            var system = HoursRulerSystem.create(entity);
            systems.add(system);
        }
        if (RenderBackgroundSystem.isCompatible(entity)) {
            var system = RenderBackgroundSystem.create(entity);
            systems.add(system);
        }
        if (RenderDigitalTimeSystem.isCompatible(entity)) {
            var system = RenderDigitalTimeSystem.create(entity);
            systems.add(system);
        }
        if (SecondsRulerRenderSystem.isCompatible(entity)) {
            var system = SecondsRulerRenderSystem.create(entity);
            systems.add(system);
        }
        if (MinutesRulerRenderSystem.isCompatible(entity)) {
            var system = MinutesRulerRenderSystem.create(entity);
            systems.add(system);
        }
        if (HoursRulerRenderSystem.isCompatible(entity)) {
            var system = HoursRulerRenderSystem.create(entity);
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
        if (ChargeSystem.isCompatible(entity)) {
            var system = ChargeSystem.create(entity);
            systems.add(system);
        }
    }

    return systems;
}

function systemsFilter(arr, byProp) {
    var res = [];
    var length = arr.size();
    for (var index = 0; index < length; index++) {
        var item = arr[index];
        if (item has :components && item.components.hasKey(byProp)) {
            res.add(item);
        }
    }

    return res;
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

    var sharedTimeComponent = timeComponentCreate();

    var entities = [{
        :name => "update time",
        :engine => self,
        :time => sharedTimeComponent,
        :oneTime => {},
        :light => {},
    }, {
        :name => "seconds ruler",
        :engine => self,
        :time => sharedTimeComponent,
        :ruler => RulerComponent.create(),
        :light => {},
    }, {
        :name => "minutes ruler",
        :engine => self,
        :time => sharedTimeComponent,
        :minutesRuler => RulerComponent.create(),
        :light => {},
    }, {
        :name => "hours ruler",
        :engine => self,
        :time => sharedTimeComponent,
        :hoursRuler => RulerComponent.create(),
        :light => {},
    }, {
        :name => "background",
        :engine => self,
        :background => {},
        :light => {},
    }, {
        :name => "charge battery",
        :engine => self,
        :charge => ChargeComponent.create(),
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
        :name => "digital time",
        :engine => self,
        :time => sharedTimeComponent,
        :digitalTime => DigitalTimeComponent.create(),
        :light => {},
    }, {
        :name => "compass",
        :engine => self,
        :stats => performanceStatisticsComponentCreate(),
        :compass => compassSensorComponentCreate(),
    }];

    var systemsAll = makeSystemsFromEntites(entities);
    var systemsLight = systemsFilter(self.systemsAll, :light);
    var systems = self.systemsAll;

    function init(width, height) {
        self.width = width;
        self.height = height;
        self.centerPoint = [width / 2, height / 2];
        self.systemsLength = self.systemsAll.size();
        for (var index = 0; index < self.systemsLength; index += 1) {
            var current = systemsAll[index];
            current.init();
        }
        var length = self.systemsLight.size();
        for (var index = 0; index < length; index += 1) {
            var current = systemsLight[index];
            current.init();
        }
    }

    function switchToLight() {
        self.systems = self.systemsLight;
        self.systemsLength = self.systems.size();
    }

    function switchToNormal() {
        self.systems = self.systemsAll;
        self.systemsLength = self.systems.size();
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

        var delta = System.getTimer() - self.lastTime;
        self.averageRenderMs = (self.averageRenderMs + delta) / 2;
    }
}

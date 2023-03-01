import Toybox.System;
import Toybox.Math;
import Toybox.Lang;

function EngineCreate() {
    var inst = new Engine();

    return inst;
}

function makeSystemsFromEntites(entities, api as API_Functions) {
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
        if (DigitalTimeSystem.isCompatible(entity)) {
            var system = DigitalTimeSystem.create(entity);
            systems.add(system);
        }
        if (RenderSecondsRulerSystem.isCompatible(entity)) {
            var system = RenderSecondsRulerSystem.create(entity);
            systems.add(system);
        }
        if (RenderMinutesRulerSystem.isCompatible(entity)) {
            var system = RenderMinutesRulerSystem.create(entity);
            systems.add(system);
        }
        if (RenderHoursRulerSystem.isCompatible(entity)) {
            var system = RenderHoursRulerSystem.create(entity);
            systems.add(system);
        }
        if (WeatherIconSystem.isCompatible(entity)) {
            var system = WeatherIconSystem.create(entity);
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
        if (BodyBatterySystem.isCompatible(entity)) {
            var system = BodyBatterySystem.create(entity);
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
        if (RenderPolygonSystem.isCompatible(entity)) {
            var system = RenderPolygonSystem.create(entity);
            systems.add(system);
        }
        if (multilineRenderSystemIsCompatible(entity)) {
            var system = multilineRenderSystemCreate(entity);
            systems.add(system);
        }
        if (SunPositionSystem.isCompatible(entity)) {
            var system = SunPositionSystem.create(entity, api);
            systems.add(system);
        }
        if (ChargeSystem.isCompatible(entity)) {
            var system = ChargeSystem.create(entity);
            systems.add(system);
        }
        if (AltTimeSystem.isCompatible(entity)) {
            var system = AltTimeSystem.create(entity, api);
            systems.add(system);
        }
        if (StepsSystem.isCompatible(entity)) {
            var system = StepsSystem.create(entity, api);
            systems.add(system);
        }
        if (HeartRateSystem.isCompatible(entity)) {
            var system = HeartRateSystem.create(entity, api);
            systems.add(system);
        }
        if (WatchStatusSystem.isCompatible(entity)) {
            var system = WatchStatusSystem.create(entity, api);
            systems.add(system);
        }
        if (RenderWatchStatusSystem.isCompatible(entity)) {
            var system = RenderWatchStatusSystem.create(entity, api);
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
    var api = API_Functions.create();
    var width = 240;
    var height = 240;
    var centerPoint = [120, 120];
    var lastTime = System.getTimer();
    var systemsLength = 0;
    var clipArea = [[100,100],[200,200]];
    var averageTickMs = 0;
    var averageRenderMs = 0;

    var context = renderContextCreate();
    var sharedTimeComponent = timeComponentCreate();
    var sharedDateComponent = dateComponentCreate();
    var sharedWatchStatus = WatchStatusComponent.create();

    var entities = [{
        :name => "update time",
        :engine => self,
        :time => sharedTimeComponent,
        :oneTime => {},
        :light => {},
    }, {
        :name => "watch status",
        :engine => self,
        :watchStatus => sharedWatchStatus,
    }, {
        :name => "seconds ruler",
        :engine => self,
        :time => sharedTimeComponent,
        :ruler => RulerComponent.create(),
        :light => {},
    }, {
        :name => "charge battery",
        :engine => self,
        :watchStatus => sharedWatchStatus,
        :charge => ChargeComponent.create(),
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
        :name => "weather",
        :engine => self,
        :weather => weatherComponentCreate(),
    }, {
        :name => "current date",
        :engine => self,
        :date => sharedDateComponent,
    }, {
        :name => "body battery",
        :engine => self,
        :bodyBattery => BodyBatteryComponent.create(),
    }, {
        :name => "stress",
        :engine => self,
        :stress => stressSensorComponentCreate(),
    }, {
        :name => "barometer",
        :engine => self,
        :barometer => barometerSensorComponentCreate(),
    }, {
        :name => "digital time",
        :engine => self,
        :time => sharedTimeComponent,
        :digitalTime => DigitalTimeComponent.create(),
        :light => {},
    }, {
        :name => "sun position",
        :engine => self,
        :sunPosition => SunPositionComponent.create(),
    }, {
        :name => "alt time in New York",
        :engine => self,
        :time => sharedTimeComponent,
        :date => sharedDateComponent,
        :altTime => AltTimeComponent.createInNewYork(),
    }, {
        :name => "alt time in Kyiv",
        :engine => self,
        :time => sharedTimeComponent,
        :date => sharedDateComponent,
        :altTime => AltTimeComponent.createInKyiv(),
    }, {
        :name => "steps count",
        :engine => self,
        :steps => StepsComponent.create(),
    }, {
        :name => "heart rate",
        :engine => self,
        :heartRate => HeartRateComponent.create(),
    }, {
        :name => "watch status render",
        :engine => self,
        :watchStatus => sharedWatchStatus,
        :render => {},
    }];

    var systemsAll = makeSystemsFromEntites(entities, self.api);
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

        var delta = System.getTimer() - currentTime;
        self.averageTickMs = (self.averageTickMs + delta) / 2;
    }

    function render(dc) {
        var currentTime = System.getTimer();
        var length = self.systemsLength;
        var index = 0;
        var n = length % 8;

        if (n > 0) {
            do {
                var current = systems[index];
                current.render(dc, self.context);
                index += 1;
                n -= 1;
            }
            while (n > 0); // n must be greater than 0 here
        }

        n = Math.floor(length / 8);
        if (n > 0) { // if iterations < 8 an infinite loop, added for safety in second printing
            do {
                var current = systems[index];
                current.render(dc, self.context);
                index += 1;
                current = systems[index];
                current.render(dc, self.context);
                index += 1;
                current = systems[index];
                current.render(dc, self.context);
                index += 1;
                current = systems[index];
                current.render(dc, self.context);
                index += 1;
                current = systems[index];
                current.render(dc, self.context);
                index += 1;
                current = systems[index];
                current.render(dc, self.context);
                index += 1;
                current = systems[index];
                current.render(dc, self.context);
                index += 1;
                current = systems[index];
                current.render(dc, self.context);
                index += 1;
                n -= 1;
            }
            while (n > 0); // n must be greater than 0 here also
        }

        var delta = System.getTimer() - currentTime;
        self.averageRenderMs = (self.averageRenderMs + delta) / 2;
    }
}

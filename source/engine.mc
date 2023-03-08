import Toybox.System;
import Toybox.Math;
import Toybox.Lang;

function EngineCreate() {
    var inst = new Engine();

    return inst;
}

function systemsFilterByMember(arr, byMember) {
    var res = [];
    var length = arr.size();
    for (var index = 0; index < length; index++) {
        var item = arr[index][0];
        if (item.hasKey(byMember)) {
            res.add(arr[index]);
        }
    }

    return res;
}

class Engine {
    var api = API_Functions.create();
    var width = 240;
    var height = 240;
    var centerPoint = [120, 120];
    var screenCenterPoint = [[120, 120]];
    var lastTime = System.getTimer();
    var systemsLength = 0;
    var clipArea = [[155,138],[89,90]];
    var averageTickMs = 0;
    var averageRenderMs = 0;

    var context = renderContextCreate();
    var sharedTimeComponent = timeComponentCreate();
    var sharedDateComponent = dateComponentCreate();
    var sharedWatchStatus = WatchStatusComponent.create();
    var sharedSunPositionComponent = SunPositionComponent.create();
    var sharedHeartRateComponent = HeartRateComponent.create();
    var sharedChargeComponent = ChargeComponent.create();
    var sharedWeatherComponent = weatherComponentCreate();
    var sharedStepsComponent = StepsComponent.create();
    var sharedBarometerSensorComponent = barometerSensorComponentCreate();

    var entities = [{
        :name => "update time",
        :engine => self,
        :time => sharedTimeComponent,
        :oneTime => {},
        :update => {},
        :light => {},
    }, {
        :name => "watch status",
        :engine => self,
        :watchStatus => sharedWatchStatus,
        :update => {},
    }, {
        :name => "charge battery",
        :engine => self,
        :watchStatus => sharedWatchStatus,
        :charge => sharedChargeComponent,
        :update => {},
    }, {
        :name => "charge battery",
        :engine => self,
        :watchStatus => sharedWatchStatus,
        :charge => sharedChargeComponent,
        :render => {},
    }, {
        :name => "background",
        :engine => self,
        :backgroundOff => {},
        :render => {},
    }, {
        :name => "minutes ruler",
        :engine => self,
        :time => sharedTimeComponent,
        :xminutesRuler => RulerComponent.create(),
        :light => {},
    }, {
        :name => "hours ruler",
        :engine => self,
        :time => sharedTimeComponent,
        :xhoursRuler => RulerComponent.create(),
        :light => {},
    }, {
        :name => "seconds ruler",
        :engine => self,
        :time => sharedTimeComponent,
        :xruler => RulerComponent.create(),
        :light => {},
    }, {
        :name => "background",
        :engine => self,
        :background => {},
        :render => {},
        :light => {},
    }, {
        :name => "background alpha",
        :engine => self,
        :backgroundAlphaOff => {},
/*    }, {
        :name => "minutes ticks",
        :engine => self,
        :minuteTicks => minuteTicksCreate(),
        :polygon => shapeComponentCreate(),
    }, {
        :name => "hour ticks",
        :engine => self,
        :hourTicks => hourTicksCreate(),
        :polygon => shapeComponentCreate(),
*/    }, {
        :name => "sun position",
        :engine => self,
        :time => sharedTimeComponent,
        :sunPosition => sharedSunPositionComponent,
        :update => {},
    }, {
        :name => "weather",
        :engine => self,
        :sunPosition => sharedSunPositionComponent,
        :weather => sharedWeatherComponent,
        :render => {},
    }, {
        :name => "weather",
        :engine => self,
        :sunPosition => sharedSunPositionComponent,
        :weather => sharedWeatherComponent,
        :update => {},
    }, {
        :name => "current date",
        :engine => self,
        :date => sharedDateComponent,
        :update => {},
    }, {
        :name => "current date",
        :engine => self,
        :date => sharedDateComponent,
        :render => {},
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
        :barometer => sharedBarometerSensorComponent,
        :update => {},
    }, {
        :name => "barometer",
        :engine => self,
        :barometer => sharedBarometerSensorComponent,
        :render => {},
    }, {
        :name => "digital time",
        :engine => self,
        :time => sharedTimeComponent,
        :digitalTime => DigitalTimeComponent.create(),
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
        :steps => sharedStepsComponent,
        :update => {},
    }, {
        :name => "steps count",
        :engine => self,
        :steps => sharedStepsComponent,
        :render => {},
    }, {
        :name => "heart rate",
        :engine => self,
        :heartRate => sharedHeartRateComponent,
    }, {
        :name => "watch status render",
        :engine => self,
        :watchStatus => sharedWatchStatus,
        :render => {},
    }, {
        :name => "moon info",
        :engine => self,
        :time => sharedTimeComponent,
        :date => sharedDateComponent,
        :moon => MoonInfoComponent.create(),
    }, {
        :name => "hours hand",
        :engine => self,
        :time => sharedTimeComponent,
        :hoursHand => hoursHandComponentCreate(),
        :polygon => shapeComponentCreate(),
    }, {
        :name => "minutes hand",
        :engine => self,
        :time => sharedTimeComponent,
        :minutesHand => minutesHandComponentCreate(),
        :polygon => shapeComponentCreate(),
    }, {
        :name => "seconds hand",
        :engine => self,
        :time => sharedTimeComponent,
        :secondsHand => secondsHandComponentCreate(),
        :polygon => shapeComponentCreate(),
        :buffer => false,
        :render => {},
        :light => {},
    }];

    var systemsAll = makeSystemsFromEntites(entities, self.api);
    var updateSystemsAll = systemsFilterByMember(self.systemsAll, :update);
    var renderSystemsAll = systemsFilterByMember(self.systemsAll, :render);
    var updateSystemsAllLength = self.updateSystemsAll.size();
    var renderSystemsAllLength = self.renderSystemsAll.size();

    var systemsLight = systemsFilterByMember(self.systemsAll, :light);
    var updateSystemsLight = systemsFilterByMember(self.systemsLight, :update);
    var renderSystemsLight = systemsFilterByMember(self.systemsLight, :render);
    var updateSystemsLightLength = self.updateSystemsLight.size();
    var renderSystemsLightLength = self.renderSystemsLight.size();

    var updateSystems = self.updateSystemsAll;
    var renderSystems = self.renderSystemsAll;
    var updateSystemsLength = self.updateSystemsAllLength;
    var renderSystemsLength = self.renderSystemsAllLength;

    function init(width, height) {
        self.width = width;
        self.height = height;
        self.centerPoint = [width / 2, height / 2];
        self.screenCenterPoint = [self.centerPoint];
        self.systemsLength = self.systemsAll.size();
        for (var index = 0; index < self.systemsLength; index += 1) {
            var current = systemsAll[index];
            if (current.size() == 3) {
                current[2].invoke(current[0], self.api);
            }
        }
        var length = self.systemsLight.size();
        for (var index = 0; index < length; index += 1) {
            var current = systemsLight[index];
            if (current.size() == 3) {
                current[2].invoke(current[0], self.api);
            }
        }
    }

    function switchToLight() {
        self.updateSystems = self.updateSystemsLight;
        self.renderSystems = self.renderSystemsLight;
        self.updateSystemsLength = self.updateSystemsLightLength;
        self.renderSystemsLength = self.renderSystemsLightLength;
    }

    function switchToNormal() {
        self.updateSystems = self.updateSystemsAll;
        self.renderSystems = self.renderSystemsAll;
        self.updateSystemsLength = self.updateSystemsAllLength;
        self.renderSystemsLength = self.renderSystemsAllLength;
    }

    function tick() {
        var currentTime = System.getTimer();
        var deltaTime = currentTime - self.lastTime;
        self.lastTime = currentTime;
        var length = self.updateSystemsLength;
        var systems = self.updateSystems;
        var index = 0;
        var n = length % 8;

        if (n > 0) {
            do {
                var current = systems[index];
                current[0][:dc] = null;
                current[0][:context] = self.context;
                current[0][:deltaTime] = deltaTime;
                current[1].invoke(current[0]);
                index += 1;
                n -= 1;
            }
            while (n > 0); // n must be greater than 0 here
        }

        n = Math.floor(length / 8);
        if (n > 0) { // if iterations < 8 an infinite loop, added for safety in second printing
            do {
                var current = systems[index];
                current[0][:dc] = null;
                current[0][:context] = self.context;
                current[0][:deltaTime] = deltaTime;
                current[1].invoke(current[0]);
                index += 1;
                current = systems[index];
                current[0][:dc] = null;
                current[0][:context] = self.context;
                current[0][:deltaTime] = deltaTime;
                current[1].invoke(current[0]);
                index += 1;
                current = systems[index];
                current[0][:dc] = null;
                current[0][:context] = self.context;
                current[0][:deltaTime] = deltaTime;
                current[1].invoke(current[0]);
                index += 1;
                current = systems[index];
                current[0][:dc] = null;
                current[0][:context] = self.context;
                current[0][:deltaTime] = deltaTime;
                current[1].invoke(current[0]);
                index += 1;
                current = systems[index];
                current[0][:dc] = null;
                current[0][:context] = self.context;
                current[0][:deltaTime] = deltaTime;
                current[1].invoke(current[0]);
                index += 1;
                current = systems[index];
                current[0][:dc] = null;
                current[0][:context] = self.context;
                current[0][:deltaTime] = deltaTime;
                current[1].invoke(current[0]);
                index += 1;
                current = systems[index];
                current[0][:dc] = null;
                current[0][:context] = self.context;
                current[0][:deltaTime] = deltaTime;
                current[1].invoke(current[0]);
                index += 1;
                current = systems[index];
                current[0][:dc] = null;
                current[0][:context] = self.context;
                current[0][:deltaTime] = deltaTime;
                current[1].invoke(current[0]);
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
        var length = self.renderSystemsLength;
        var systems = self.renderSystems;
        var index = 0;
        var n = length % 8;
        self.context.dc = dc;

        if (n > 0) {
            do {
                var current = systems[index];
                current[0][:dc] = dc;
                current[0][:context] = self.context;
                current[1].invoke(current[0]);
                index += 1;
                n -= 1;
            }
            while (n > 0); // n must be greater than 0 here
        }

        n = Math.floor(length / 8);
        if (n > 0) { // if iterations < 8 an infinite loop, added for safety in second printing
            do {
                var current = systems[index];
                current[0][:dc] = dc;
                current[0][:context] = self.context;
                current[1].invoke(current[0]);
                index += 1;
                current = systems[index];
                current[0][:dc] = dc;
                current[0][:context] = self.context;
                current[1].invoke(current[0]);
                index += 1;
                current = systems[index];
                current[0][:dc] = dc;
                current[0][:context] = self.context;
                current[1].invoke(current[0]);
                index += 1;
                current = systems[index];
                current[0][:dc] = dc;
                current[0][:context] = self.context;
                current[1].invoke(current[0]);
                index += 1;
                current = systems[index];
                current[0][:dc] = dc;
                current[0][:context] = self.context;
                current[1].invoke(current[0]);
                index += 1;
                current = systems[index];
                current[0][:dc] = dc;
                current[0][:context] = self.context;
                current[1].invoke(current[0]);
                index += 1;
                current = systems[index];
                current[0][:dc] = dc;
                current[0][:context] = self.context;
                current[1].invoke(current[0]);
                index += 1;
                current = systems[index];
                current[0][:dc] = dc;
                current[0][:context] = self.context;
                current[1].invoke(current[0]);
                index += 1;
                n -= 1;
            }
            while (n > 0); // n must be greater than 0 here also
        }

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_DK_GRAY);
		dc.fillCircle(130, 130, 10);
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_LT_GRAY);
		dc.fillCircle(130, 130, 9);
		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_LT_GRAY);
		dc.fillCircle(130, 130, 4);

        var delta = System.getTimer() - currentTime;
        self.averageRenderMs = (self.averageRenderMs + delta) / 2;
    }
}

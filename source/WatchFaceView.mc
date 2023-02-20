import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class WatchFaceView extends WatchUi.WatchFace {
    private var api = API_Functions.Create();
    //private var engine = EngineCreate();
    private var engineV2 = makeEngineV2();
    private var timing = makeEngineTiming(self.engineV2);
    private var engineContext = makeEngineContextComponent();

    private var font as FontResource?;
    private var background;
    private var timer = mainTimerCreate(method(:engineTick));
    private var sleepMode = false;

    function initialize() {
        WatchFace.initialize();

        self.font = WatchUi.loadResource(Rez.Fonts.weather32) as FontResource;
        self.background = WatchUi.loadResource( Rez.Drawables.background );
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));

        dc.drawBitmap(0, 0, background);

        var width = dc.getWidth();
        var height = dc.getHeight();
        self.engineContext.width = width;
        self.engineContext.height = height;
        self.engineContext.centerPoint[0] = width / 2;
        self.engineContext.centerPoint[1] = height / 2;

        var watchTime = self.engineV2.makeEntity("watch-time");
        var watchDate = self.engineV2.makeEntity("watch-date");
        var minuteTicks = self.engineV2.makeEntity("minute-ticks");
        var hourTicks = self.engineV2.makeEntity("hour-ticks");
        var hoursHand = self.engineV2.makeEntity("hours-hand");
        var minutesHand = self.engineV2.makeEntity("mintures-hand");
        var secondsHand = self.engineV2.makeEntity("seconds-hand");
        var weatherRegion = self.engineV2.makeEntity("weather-region");
        var stressSensor = self.engineV2.makeEntity("stress-region");
        var barometerSensor = self.engineV2.makeEntity("barometer-region");

        var sharedTimeComponent = timeComponentCreate();
        watchTime.setComponent(:context, self.engineContext);
        watchTime.setComponent(:time, sharedTimeComponent);
        watchTime.setComponent(:readTime, {});

        watchDate.setComponent(:context, self.engineContext);
        watchDate.setComponent(:date, dateComponentCreate());
        watchDate.setComponent(:titles, makeTitlesComponent());

        minuteTicks.setComponent(:context, self.engineContext);
        minuteTicks.setComponent(:minuteTicks, minuteTicksCreate());
        minuteTicks.setComponent(:polygon, shapeComponentCreate());

        hourTicks.setComponent(:context, self.engineContext);
        hourTicks.setComponent(:hourTicks, hourTicksCreate());
        hourTicks.setComponent(:polygon, shapeComponentCreate());

        hoursHand.setComponent(:context, self.engineContext);
        hoursHand.setComponent(:time, sharedTimeComponent);
        hoursHand.setComponent(:hoursHand, hoursHandComponentCreate());
        hoursHand.setComponent(:polygon, shapeComponentCreate());
        hoursHand.setComponent(:multiline, {});

        minutesHand.setComponent(:context, self.engineContext);
        minutesHand.setComponent(:time, sharedTimeComponent);
        minutesHand.setComponent(:minutesHand, minutesHandComponentCreate());
        minutesHand.setComponent(:polygon, shapeComponentCreate());
        minutesHand.setComponent(:multiline, {});

        secondsHand.setComponent(:context, self.engineContext);
        secondsHand.setComponent(:time, sharedTimeComponent);
        secondsHand.setComponent(:secondsHand, secondsHandComponentCreate());
        secondsHand.setComponent(:polygon, shapeComponentCreate());
        secondsHand.setComponent(:secondsArrowPolygon, {});

        weatherRegion.setComponent(:context, self.engineContext);
        weatherRegion.setComponent(:weather, weatherComponentCreate());
        weatherRegion.setComponent(:titles, makeTitlesComponent());

        stressSensor.setComponent(:context, self.engineContext);
        stressSensor.setComponent(:stress, stressSensorComponentCreate());
        stressSensor.setComponent(:titles, makeTitlesComponent());

        barometerSensor.setComponent(:context, self.engineContext);
        barometerSensor.setComponent(:barometer, barometerSensorComponentCreate());
        barometerSensor.setComponent(:gauge, makeGaugeComponent());
        barometerSensor.setComponent(:titles, makeTitlesComponent());

        self.engineV2.makeSystem("updateCurrentTime", [:context, :time, :readTime], makeUpdateTimeDelegate());
        self.engineV2.makeSystem("updateCurrentDate", [:context, :date, :titles], makeUpdateCurrentDateDelegate());
        self.engineV2.makeSystem("updateMinuteTicks", [:context, :minuteTicks, :polygon], makeUpdateMinuteTicksDelegate());
        self.engineV2.makeSystem("updateHourTicks", [:context, :hourTicks, :polygon], makeUpdateHourTicksDelegate());
        self.engineV2.makeSystem("updateHoursHand", [:context, :time, :hoursHand, :polygon], makeUpdateHoursHandDelegate());
        self.engineV2.makeSystem("updateMinutesHand", [:context, :time, :minutesHand, :polygon], makeUpdateMinutesHandDelegate());
        self.engineV2.makeSystem("updateSecondsHand", [:context, :time, :secondsHand, :polygon], makeUpdateSecondsHandDelegate());
        self.engineV2.makeSystem("updateWeatherInfo", [:context, :weather, :titles], makeUpdateWeatherDelegate());
        self.engineV2.makeSystem("updateStressSensor", [:context, :stress, :titles], makeUpdateStressSensorDelegate());
        self.engineV2.makeSystem("updateBarometerSensor", [:context, :barometer, :gauge, :titles], makeUpdateBarometerSensorDelegate());
        self.engineV2.makeSystem("renderGauge", [:context, :gauge], makeRenderGaugeDelegate());
        self.engineV2.makeSystem("renderPolygon", [:context, :polygon], makeRenderPolygonDelegate());
        self.engineV2.makeSystem("renderMultiline", [:context, :polygon, :multiline], makeRenderMultilineDelegate());
        self.engineV2.makeSystem("renderText", [:context, :titles], makeTitlesRenderDelegate());
        self.engineV2.makeSystem("renderSecondsArrowPolygon", [:context, :polygon, :secondsArrowPolygon], makeRenderPolygonDelegate());

        //self.engine.init(width, height);
        //self.engine.tick();
        self.engineV2.preTick();
        self.engineContext.dc = dc;
        self.engineV2.tick();

        //self.engine.render(dc);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        self.timer.nextTick();
        if (self.sleepMode == false) {
            self.timer.start();
        }
    }

    function engineTick(deltaTime) as Void {
        //self.engine.tick();
        self.engineContext.dc = null;
        self.engineV2.tick();
        WatchUi.requestUpdate();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        if (self.sleepMode) {
            dc.clearClip();
            self.sleepMode = false;
        }
        //self.engine.tick();
        self.engineContext.dc = dc;

        //dc.drawBitmap(0, 0, background);
        dc.setColor(0, Graphics.COLOR_BLACK);
        dc.clear();

        self.engineV2.tick();
        //self.debugClipArea(dc);

        //self.engine.render(dc);

        self.drawTimingLog(dc);
    }

    function drawTimingLog(dc) {
        var timing = self.timing.getTime();
        var stats = Lang.format("$1$, $2$", [
            timing.delta, self.engineV2.averageTickMs
        ]);
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(130, 90, Graphics.FONT_XTINY, stats, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function debugClipArea(dc) {
        dc.setColor(Graphics.COLOR_LT_GRAY, 0);
        dc.drawRectangle(
            self.engineContext.clipArea[0][0],
            self.engineContext.clipArea[0][1],
            self.engineContext.clipArea[1][0],
            self.engineContext.clipArea[1][1]
        );
    }

    // Handle the partial update event
    function onPartialUpdate( dc ) {
        self.sleepMode = true;
        //self.engine.tick();
        self.engineContext.dc = dc;
        // If we're not doing a full screen refresh we need to re-draw the background
        // before drawing the updated second hand position. Note this will only re-draw
        // the background in the area specified by the previously computed clipping region.

        dc.setClip(
            self.engineContext.clipArea[0][0],
            self.engineContext.clipArea[0][1],
            self.engineContext.clipArea[1][0],
            self.engineContext.clipArea[1][1]
        );

        dc.setColor(0, Graphics.COLOR_BLACK);
        dc.clear();

        self.engineV2.tick();

        //self.engine.render(dc);
        self.drawTimingLog(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        self.timer.stop();
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        self.timer.nextTick();
        self.timer.start();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        self.sleepMode = true;
        self.timer.stop();
    }
}

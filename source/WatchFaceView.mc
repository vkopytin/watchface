import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class WatchFaceView extends WatchUi.WatchFace {
    private var api = API_Functions.Create();
    private var engine = EngineCreate();

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

        self.engine.init(width, height);
        self.engine.tick();

        self.engine.render(dc);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        self.timer.nextTick();
        self.timer.start();
    }

    function engineTick(deltaTime) as Void {
        self.engine.tick();
        WatchUi.requestUpdate();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        if (self.sleepMode) {
            dc.clearClip();
            self.sleepMode = false;
        }
        self.engine.tick();

        //dc.drawBitmap(0, 0, background);
        dc.setColor(0, Graphics.COLOR_BLACK);
        dc.clear();

        //self.debugClipArea(dc);

        self.engine.render(dc);
    }

    function debugClipArea(dc) {
        dc.setColor(Graphics.COLOR_LT_GRAY, 0);
        dc.drawRectangle(
            self.engine.clipArea[0][0],
            self.engine.clipArea[0][1],
            self.engine.clipArea[1][0],
            self.engine.clipArea[1][1]
        );
    }

    // Handle the partial update event
    function onPartialUpdate( dc ) {
        self.sleepMode = true;
        self.engine.tick();
        // If we're not doing a full screen refresh we need to re-draw the background
        // before drawing the updated second hand position. Note this will only re-draw
        // the background in the area specified by the previously computed clipping region.

        dc.setClip(
            self.engine.clipArea[0][0],
            self.engine.clipArea[0][1],
            self.engine.clipArea[1][0],
            self.engine.clipArea[1][1]
        );

        dc.setColor(0, Graphics.COLOR_BLACK);
        dc.clear();

        self.engine.render(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {

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

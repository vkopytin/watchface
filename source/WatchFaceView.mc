import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class WatchFaceView extends WatchUi.WatchFace {
    private var engine = EngineCreate();

    private var font as FontResource?;
    private var ruler;
    private var timer = MainTimer.create(self);
    private var sleepMode = false;

    function initialize() {
        WatchFace.initialize();

        self.font = WatchUi.loadResource(Rez.Fonts.weather32) as FontResource;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        //setLayout(Rez.Layouts.WatchFace(dc));

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
        if (self.sleepMode == false) {
            self.timer.start();
        }
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
            self.engine.switchToNormal();
            self.engine.tickWithDelta(60 * 1000);
        }

        self.engine.render(dc);

        //self.debugClipArea(dc);

        var stats = self.engine.averageTickMs + "-" + self.engine.averageRenderMs;
        dc.setColor(0x555555, Graphics.COLOR_TRANSPARENT);
        dc.drawText(130, 235, Graphics.FONT_XTINY, stats, Graphics.TEXT_JUSTIFY_CENTER);
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
        self.engine.switchToLight();
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

        //dc.clear();

        self.engine.render(dc);
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

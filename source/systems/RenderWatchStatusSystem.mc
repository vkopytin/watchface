import Toybox.Lang;

class RenderWatchStatusSystem {
    static function create(components, api as API_Functions) as RenderWatchStatusSystem {
        var inst = new RenderWatchStatusSystem(components, api);

        return inst;
    }

    static function isCompatible(entity) as Boolean {
        return entity.hasKey(:watchStatus) and entity.hasKey(:render);
    }

    var api as API_Functions;

    var engine as Engine;
    var watchStatus as WatchStatusComponent;

    var statusIcons;

    function initialize(components, api) {
        self.api = api;
        self.engine = components[:engine] as Engine;
        self.watchStatus = components[:watchStatus] as WatchStatusComponent;
    }

    function init() {
        self.statusIcons = WatchUi.loadResource(Rez.Fonts.system12);
    }

    function render(dc, context) {
        context.dc.setColor(self.watchStatus.color, Graphics.COLOR_TRANSPARENT);
        context.dc.drawText(
            self.watchStatus.position[0], self.watchStatus.position[1],
            self.statusIcons, self.watchStatus.solarStatusIcon, Graphics.TEXT_JUSTIFY_LEFT
        );
        if (self.watchStatus.phoneConnected) {
            context.dc.setColor(0x005555, Graphics.COLOR_TRANSPARENT);
            context.dc.drawText(
                self.watchStatus.position[0], self.watchStatus.position[1] - 12,
                self.statusIcons, "2", Graphics.TEXT_JUSTIFY_LEFT
            );
        } else {
            context.dc.setColor(0x55ffff, Graphics.COLOR_TRANSPARENT);
            context.dc.drawText(
                self.watchStatus.position[0], self.watchStatus.position[1] - 12,
                self.statusIcons, "1", Graphics.TEXT_JUSTIFY_LEFT
            );
        }
    }
}

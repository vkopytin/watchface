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

    function update(deltaTime as Long) {

    }

    function render(dc, context) {
        dc.setColor(self.watchStatus.color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            self.watchStatus.position[0], self.watchStatus.position[1],
            self.statusIcons, self.watchStatus.solarStatusIcon, Graphics.TEXT_JUSTIFY_LEFT
        );
    }
}
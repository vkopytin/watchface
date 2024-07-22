using Toybox.Graphics;
using Toybox.Lang;

class HeartRateComponent {
    static function create() {
        return new HeartRateComponent();
    }
    var data = [];
    var dataLength = 0;
    var color = 0x005555;
    var position = [40, 175];
    var value = "--";

    var fastUpdate = (5 * 1000) as Lang.Long; // keep fast updates for 5 secs
    var accumulatedTime = 0 as Lang.Long;

	var arrayColours = [Graphics.COLOR_DK_GRAY, Graphics.COLOR_RED, Graphics.COLOR_DK_RED, Graphics.COLOR_ORANGE, Graphics.COLOR_YELLOW, Graphics.COLOR_GREEN, Graphics.COLOR_DK_GREEN, Graphics.COLOR_BLUE, Graphics.COLOR_DK_BLUE, Graphics.COLOR_PURPLE, Graphics.COLOR_PINK];
	var heartRateZones = [];
	var useZonesColour = true;
	var graphColour = 1;
	var totHeight = 40;
	var totWidth = 40;
	var moveBarLevel;
}

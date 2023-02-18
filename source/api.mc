import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class API_Functions {
    static function Create() {
        var inst = new API_Functions();

        return inst;
    }

    function generateHandCoordinates(centerPoint, angle, handLength, tailLength, width, triangle) {
        // Map out the coordinates of the watch hand
        var coords = [
            [-(width / 2), tailLength],
            [-(width / 2), -handLength],
            [0,- handLength * triangle],
            [width / 2, -handLength],
            [width / 2, tailLength]
        ];
        var result = new [5];
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);

        // Transform the coordinates
        for (var i = 0; i < 5; i += 1) {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin) + 0.5;
            var y = (coords[i][0] * sin) + (coords[i][1] * cos) + 0.5;

            result[i] = [centerPoint[0] + x, centerPoint[1] + y];
        }

        return result;
    }

    function drawHand(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();

        var triangle = 1.09;
        var handWidth = 10;

        var clockTime = System.getClockTime();
		var screenCenterPoint = [width/2, height/2];

        var hourHandAngle = Math.PI/6 * (1.0*clockTime.hour + clockTime.min/60.0);
        var minuteHandAngle = (clockTime.min / 30.0) * Math.PI;
        var secondHandAngle = (clockTime.sec / 30.0) * Math.PI;

        var borderColor=Graphics.COLOR_DK_GREEN, arborColor=Graphics.COLOR_LT_GRAY; 

        dc.setColor(borderColor, Graphics.COLOR_TRANSPARENT); //(centerPoint, angle, handLength, tailLength, width, triangle)
        //var handleLength = width / 3.485;
        var handleLength = (width - 30) / 2;
		dc.fillPolygon(generateHandCoordinates(screenCenterPoint, secondHandAngle, handleLength, 0, Math.ceil(handWidth+(width*0.01)), triangle)); // hour hand border

		var offsetInnerCircle = 0;
		var offsetOuterCircle = 0;
        dc.setColor(borderColor,Graphics.COLOR_BLACK);
		dc.fillCircle(width / 2, height / 2, handWidth*0.65-offsetOuterCircle); // *0.65
		dc.setColor(arborColor, Graphics.COLOR_WHITE);
		dc.fillCircle(width / 2, height / 2, handWidth*0.65-offsetInnerCircle); // -4
    }

}

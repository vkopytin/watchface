import Toybox.Lang;
import Toybox.Graphics;

function stressSensorComponentCreate() as StressSensorComponent {
    var inst = new StressSensorComponent();

    return inst;
}

class StressSensorComponent {
    var fastUpdate = (5 * 1000) as Long; // keep fast updates for 5 secs
    var accumulatedTime = 0 as Long;

    var color = Graphics.COLOR_GREEN;
    var position = [0, 80];
    
    var value = 0;

    var point = [0, 0];
}

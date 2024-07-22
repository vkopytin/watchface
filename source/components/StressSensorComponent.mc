using Toybox.Lang;

function stressSensorComponentCreate() as StressSensorComponent {
    var inst = new StressSensorComponent();

    return inst;
}

class StressSensorComponent {
    var color = 0x005555;
    var position = [70, 210];
    
    var value = 0;
    var width = 100;
    var height = 8;
    var currentWidth = 20;
    var strValue = "";
    var deltaIndex = 0;

    var fastUpdate = (5 * 1000) as Lang.Long; // keep fast updates for 5 secs
    var accumulatedTime = 0 as Lang.Long;
    var stressRuler;
}

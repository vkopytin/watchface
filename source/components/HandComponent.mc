import Toybox.Lang;
import Toybox.Graphics;

function secondsHandComponentCreate() {
    var inst = new HandComponent();

    var longArrow = [
        [-4, 20],
        [-2, 2],
        [0, -130],
        [2, 2],
        [4, 20],
    ];
    var smallArrow = [
        [0, -110],
        [-4, -128],
        [0, -123],
        [4, -128],
        [0, -110],
    ];
    inst.coordinates = longArrow;
    inst.fastUpdate = (1 * 1000) as Long; // keep fast updates for 1 secs
    inst.color = 0xff5500;
    inst.mesh = inst.coordinates;

    return inst;
}

function minutesHandComponentCreate() {
    var inst = new HandComponent();

    inst.coordinates = [
        [-3, 0],
        [-7, -70],
        [0, -115],
        [7, -70],
        [3, 0],
    ];
    inst.fastUpdate = (5 * 1000) as Long; // skip updates for 5 secs
    inst.color = Graphics.COLOR_DK_GREEN;
    inst.mesh = inst.coordinates;

    return inst;
}

function hoursHandComponentCreate() {
    var inst = new HandComponent();

    inst.coordinates = [
        [-3, 0],
        [-10, -60],
        [0, -100],
        [10, -60],
        [3, 0],
    ];
    inst.fastUpdate = (5 * 60 * 1000) as Long; // skip updates for 5 mins
    inst.color = Graphics.COLOR_DK_GREEN;
    inst.mesh = inst.coordinates;

    return inst;
}

class HandComponent {
    var fastUpdate = (1 * 1000) as Long; // keep fast updates for 1 secs
    var accumulatedTime = 0 as Long;
    
    var mesh = [] as Lang.Array<Lang.Array<Lang.Numeric>>;
    var coordinates = [] as Lang.Array<Lang.Array<Lang.Numeric>>;
    var color = Graphics.COLOR_YELLOW;
}

import Toybox.Lang;
import Toybox.Graphics;

function secondsHandComponentCreate() {
    var inst = new HandComponent();

    inst.coordinates = [
        [-4, 20],
        [-2, 2],
        [0, -130],
        [2, 2],
        [4, 20],
    ];
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
    inst.color = Graphics.COLOR_DK_GREEN;
    inst.mesh = inst.coordinates;

    return inst;
}

class HandComponent {
    var mesh = [] as Lang.Array<Lang.Array<Lang.Numeric>>;
    var coordinates = [] as Lang.Array<Lang.Array<Lang.Numeric>>;
    var color = Graphics.COLOR_YELLOW;
}

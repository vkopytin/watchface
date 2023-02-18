import Toybox.Lang;
import Toybox.Graphics;

var secondsCoords = [
    [-4, 20],
    [-2, 2],
    [0, -130],
    [2, 2],
    [4, 20],
];

var minutesCoords = [
    [-3, 0],
    [-7, -70],
    [0, -115],
    [7, -70],
    [3, 0],
];

var hoursCoords = [
    [-3, 0],
    [-10, -60],
    [0, -100],
    [10, -60],
    [3, 0],
];

function secondsHandComponentCreate() {
    var inst = new HandComponent();

    inst.color = 0xff5500;
    inst.mesh = secondsCoords;

    return inst;
}

function minutesHandComponentCreate() {
    var inst = new HandComponent();

    inst.color = Graphics.COLOR_DK_GREEN;
    inst.mesh = minutesCoords;

    return inst;
}

function hoursHandComponentCreate() {
    var inst = new HandComponent();

    inst.color = Graphics.COLOR_DK_GREEN;
    inst.mesh = hoursCoords;

    return inst;
}

class HandComponent {
    var mesh = [] as Lang.Array<Lang.Array<Lang.Numeric>>;
    var coordinates = [] as Lang.Array<Lang.Array<Lang.Numeric>>;
    var color = Graphics.COLOR_YELLOW;
}

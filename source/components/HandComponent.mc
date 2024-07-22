import Toybox.Lang;
import Toybox.Graphics;

function secondsHandComponentCreate() {
    var inst = new HandComponent();

    inst.sleepModeCoordinates = [[0xff5500, [
        [3.0,-40.0],
        [1.0, -125.0],
        [0.0, -125.0],
        [-3.0,-40.0],
    ]]];
    inst.coordinates = [
        [0x000000, [
            [0, 33],
            [0, 25],
            [2, 25],
            [2, 10], 
            [0, 10], 
            [0,-44],
            [3,-40],
            [4, 0],
            [6, 30],
        ]],
        [0x555555, [
            [0, 33],
            [0, 25],
            [-2,25],
            [-2,10],
            [0, 10],
            [0,-44],
            [-3,-40],
            [-4, 0],
            [-6,30],
        ]],
        //inst.sleepModeCoordinates[0]
    ];
    inst.color = 0xff5500;
    inst.mesh = inst.coordinates;

    return inst;
}

function minutesHandComponentCreate() {
    var inst = new HandComponent();

    inst.coordinates = [
        [0x000000, [
            [9, 27],
            [0, 30],
            [0, 3],
            [5, 3],
            [5,-20],
            [9,-25],
        ]],
        [0x555555, [
            [-9, 27],
            [0, 30],
            [0, 3],
            [-5, 3],
            [-5,-20],
            [-9,-25],
        ]], [0xaaaaaa, [
            [6,-20],
            [9,-25],
            [7,-100],
            [0,-115],
            [0,-107],
            [4,-99],
            [6,-41],
            [0,-41],
            [0,-35],
            [6,-35],
        ]], [0xffffff, [
            [-6,-20],
            [-9,-25],
            [-7,-100],
            [0,-115],
            [0,-107],
            [-4,-99],
            [-6,-41],
            [0,-41],
            [0,-35],
            [-6,-35],
        ]],
    ];
    inst.color = Graphics.COLOR_DK_GREEN;
    inst.mesh = inst.coordinates;

    return inst;
}

function hoursHandComponentCreate() {
    var inst = new HandComponent();

    inst.coordinates = [
        [0x000055, [
            [10, 21],
            [0, 25],
            [0, 3],
            [7, 3],
            [7,-15],
            [10,-20],
        ]],
        [0x555500, [
            [-10, 21],
            [0, 25],
            [0, 3],
            [-7, 3],
            [-7,-15],
            [-10,-20],
        ]], [0xaaaa55, [
            [6,-15],
            [10,-20],
            [8,-75],
            [0,-90],
            [0,-81],
            [4,-73],
            [5,-46],
            [0,-46],
            [0,-40],
            [6,-40],
        ]], [0xffffaa, [
            [-6,-15],
            [-10,-20],
            [-8,-75],
            [0,-90],
            [0,-81],
            [-4,-73],
            [-5,-46],
            [0,-46],
            [0,-40],
            [-6,-40],
        ]],
    ];
    inst.color = Graphics.COLOR_DK_GREEN;
    inst.mesh = inst.coordinates;

    return inst;
}

class HandComponent {
    var mesh = [] as Lang.Array<Lang.Array<Lang.Numeric>>;
    var sleepModeCoordinates = [];
    var coordinates = [] as Lang.Array<Lang.Array<Lang.Numeric>>;
    var color = Graphics.COLOR_YELLOW;
    var clipAreas;
}

function hourTicksCreate() as HourTicksComponent {
    var inst = new HourTicksComponent();

    return inst;
}

class HourTicksComponent {
    var color = Graphics.COLOR_DK_GREEN;

    var mesh = [
        [-2, 120],
        [-2, 128],
        [2, 128],
        [2, 120],
    ];
}

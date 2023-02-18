function minuteTicksCreate() as MinuteTicksComponent {
    var inst = new MinuteTicksComponent();

    return inst;
}

class MinuteTicksComponent {
    var color = Graphics.COLOR_GREEN;

    var mesh = [
        [-1, 124],
        [-1, 127],
        [1, 127],
        [1, 124],
    ];
}

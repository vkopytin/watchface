function shapeComponentCreate() as ShapeComponent {
    var inst = new ShapeComponent();

    return inst;
}

class ShapeComponent {
    var color = Graphics.COLOR_GREEN;

    var mesh = [[0, [[0, 0], [10, 10]]]];
}

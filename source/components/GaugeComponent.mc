import Toybox.Graphics;

function makeGaugeComponent() {
    return new GaugeComponent();
}

class GaugeComponent {
    var point;
    var radius;
    var value;
    var color = Graphics.COLOR_DK_RED;
    var colors = [];
    var ranges = [];
}

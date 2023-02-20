import Toybox.Graphics;

function makeTitlesComponent() {
    return new TitlesComponent();
}

class TitlesComponent {
    var color = Graphics.COLOR_DK_GRAY;
    var titles = [[100, 100, Graphics.FONT_SMALL, "text", Graphics.TEXT_JUSTIFY_LEFT]];
}

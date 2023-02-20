import Toybox.Lang;
import Toybox.Graphics;

class TitlesRender {
    function exec(entity, components) {
        var titles = components[:titles];
        var context = components[:context];
        var dc = context.dc;

        if (dc == null) {
            return;
        }

        var length = titles.titles.size();
        for (var index = 0; index < length; index++) {
            var title = titles.titles[index];
            dc.setColor(titles.color, Graphics.COLOR_TRANSPARENT);

            dc.drawText(title[0], title[1], title[2], title[3], title[4]);
        }
    }
}

function makeTitlesRenderDelegate() {
    return new TitlesRender();
}

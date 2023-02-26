function stressSensorComponentCreate() as StressSensorComponent {
    var inst = new StressSensorComponent();

    return inst;
}

class StressSensorComponent {
    var color = Graphics.COLOR_GREEN;
    var position = [0, 80];
    
    var value = 0;
    var strValue = "";
    var deltaIndex = 0;

    var point = [0, 0];
}

function stressSensorComponentCreate() as StressSensorComponent {
    var inst = new StressSensorComponent();

    return inst;
}

class StressSensorComponent {
    var color = 0x005555;
    var position = [128, 66];
    
    var value = 0;
    var width = 100;
    var height = 8;
    var currentWidth = 20;
    var strValue = "";
    var deltaIndex = 0;
}

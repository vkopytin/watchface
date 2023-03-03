function stressSensorComponentCreate() as StressSensorComponent {
    var inst = new StressSensorComponent();

    return inst;
}

class StressSensorComponent {
    var color = 0x005555;
    var position = [128, 64];
    
    var value = 0;
    var strValue = "";
    var deltaIndex = 0;
}

class Barcode {
  int id;
  String barcode;
  int itemCODE;
  int typeVAL;
  int unitCODE;
  String unitNAME;

  Barcode(
      {this.id,
        this.barcode,
        this.itemCODE,
        this.typeVAL,
        this.unitCODE,
        this.unitNAME,
        });

  Barcode.fromJson(json) {
    id = json['id'];
    barcode = json['barcode'];
    itemCODE = json['item_CODE'];
    typeVAL = json['type_VAL'];
    unitCODE = json['unit_CODE'];
    unitNAME = json['unit_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['barcode'] = this.barcode;
    data['item_CODE'] = this.itemCODE;
    data['type_VAL'] = this.typeVAL;
    data['unit_CODE'] = this.unitCODE;
    data['unit_NAME'] = this.unitNAME;
    return data;
  }
}
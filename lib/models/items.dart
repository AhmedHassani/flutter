class Items {
  double balance;
  int categoryCode;
  String categoryIMAGEPATH;
  String categoryNAME;
  String categoryNAMEEN;
  bool dfBUY;
  bool dfSALE;
  bool dfSTORE;
  String fullNAME;
  int id;
  String imgURL;
  bool isUSED;
  int itemCode;
  String itemNAME;
  String itemNAMEEN;
  String itemNOTE;
  String itemNOTEEN;
  int itemCODE;
  double priceAVGCOST;
  double priceBUY;
  double priceCOST;
  double priceSALE1;
  double priceSALE2;
  double priceSALE3;
  double priceSALECUR;
  int storeCODE;
  String storeNAME;
  int typeCODE;
  int unitCODE;
  String unitNAME;
  double unitQTY;

  Items(
      {this.balance,
        this.categoryCode,
        this.categoryIMAGEPATH,
        this.categoryNAME,
        this.categoryNAMEEN,
        this.dfBUY,
        this.dfSALE,
        this.dfSTORE,
        this.fullNAME,
        this.id,
        this.imgURL,
        this.isUSED,
        this.itemCode,
        this.itemNAME,
        this.itemNAMEEN,
        this.itemNOTE,
        this.itemNOTEEN,
        this.priceAVGCOST,
        this.priceBUY,
        this.itemCODE,
        this.priceCOST,
        this.priceSALE1,
        this.priceSALE2,
        this.priceSALE3,
        this.priceSALECUR,
        this.storeCODE,
        this.storeNAME,
        this.typeCODE,
        this.unitCODE,
        this.unitNAME,
        this.unitQTY});

  Items.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    categoryCode = json['categoryCode'];
    categoryIMAGEPATH = json['category_IMAGE_PATH'];
    categoryNAME = json['category_NAME'];
    categoryNAMEEN = json['category_NAME_EN'];
    dfBUY = json['df_BUY'];
    dfSALE = json['df_SALE'];
    dfSTORE = json['df_STORE'];
    fullNAME = json['full_NAME'];
    itemCODE = json['item_CODE'];
    id = json['id'];
    imgURL = json['img_URL'];
    isUSED = json['is_USED'];
    itemCode = json['itemCode'];
    itemNAME = json['item_NAME'];
    itemNAMEEN = json['item_NAME_EN'];
    itemNOTE = json['item_NOTE'];
    itemNOTEEN = json['item_NOTE_EN'];
    priceAVGCOST = json['price_AVG_COST'];
    priceBUY = json['price_BUY'];
    priceCOST = json['price_COST'];
    priceSALE1 = json['price_SALE_1'];
    priceSALE2 = json['price_SALE_2'];
    priceSALE3 = json['price_SALE_3'];
    priceSALECUR = json['price_SALE_CUR'];
    storeCODE = json['store_CODE'];
    storeNAME = json['store_NAME'];
    typeCODE = json['type_CODE'];
    unitCODE = json['unit_CODE'];
    unitNAME = json['unit_NAME'];
    unitQTY = json['unit_QTY'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['categoryCode'] = this.categoryCode;
    data['category_IMAGE_PATH'] = this.categoryIMAGEPATH;
    data['category_NAME'] = this.categoryNAME;
    data['category_NAME_EN'] = this.categoryNAMEEN;
    data['df_BUY'] = this.dfBUY;
    data['df_SALE'] = this.dfSALE;
    data['df_STORE'] = this.dfSTORE;
    data['full_NAME'] = this.fullNAME;
    data['id'] = this.id;
    data['img_URL'] = this.imgURL;
    data['is_USED'] = this.isUSED;
    data['itemCode'] = this.itemCode;
    data['item_NAME'] = this.itemNAME;
    data['item_NAME_EN'] = this.itemNAMEEN;
    data['item_NOTE'] = this.itemNOTE;
    data['item_NOTE_EN'] = this.itemNOTEEN;
    data['price_AVG_COST'] = this.priceAVGCOST;
    data['price_BUY'] = this.priceBUY;
    data['price_COST'] = this.priceCOST;
    data['price_SALE_1'] = this.priceSALE1;
    data['price_SALE_2'] = this.priceSALE2;
    data['price_SALE_3'] = this.priceSALE3;
    data['price_SALE_CUR'] = this.priceSALECUR;
    data['store_CODE'] = this.storeCODE;
    data['store_NAME'] = this.storeNAME;
    data['item_CODE'] = this.itemCODE;
    data['type_CODE'] = this.typeCODE;
    data['unit_CODE'] = this.unitCODE;
    data['unit_NAME'] = this.unitNAME;
    data['unit_QTY'] = this.unitQTY;
    return data;
  }
}

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class BarcodeShow extends StatefulWidget {
  String t_sales;
  String t_sales_detiles;
  BarcodeShow(this.t_sales,this.t_sales_detiles);

  @override
  _BarcodeShowState createState() => _BarcodeShowState();
}

class _BarcodeShowState extends State<BarcodeShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("T - Seals Barcode "),
          Container(
            height:400,
            child: SfBarcodeGenerator(
              value: widget.t_sales_detiles,
              symbology: QRCode(),
              showValue: true,
            ),
          ),
          Text("T - Seals Detiles Barcode "),
          Container(
            height:300,
            child: SfBarcodeGenerator(
              value: "ahmed",
              symbology: QRCode(),
              showValue: true,
            ),
          ),
        ],
      ),
    );
  }


}

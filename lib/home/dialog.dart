import 'package:flutter/material.dart';
import 'package:simple_app/models/items.dart';


class DialogFilter extends StatefulWidget {
  List<Items> items;
  String category;
  DialogFilter(this.items, this.category);

  @override
  _DialogFilterState createState() => _DialogFilterState();
}

class _DialogFilterState extends State<DialogFilter> {
  var listtype=[1,2];
  int valueChose;
  int unitcode;

  @override
  Widget build(BuildContext context) {
    List<Items> itemsFilter = widget.items ==null ?[]:widget.items;
    return  AlertDialog(
        title: Text("Filter"),
        contentPadding: EdgeInsets.zero,
        content: Container(
          height: 300,
          child: Column(
            children: [
              Container(
                height: 40,
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    )),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                          style: TextStyle(wordSpacing: 2,color: Colors.black),
                          underline: SizedBox(),
                          isExpanded: true,
                          value: valueChose,
                          onChanged: (newValue){

                            setState(() {
                              valueChose=newValue;
                            });
                          },
                          items: _ItemsFilter(itemsFilter).map((item)  {
                            return DropdownMenuItem(
                                value: item.storeCODE,
                                child:Text(item.storeNAME)
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("المخزن"),
                    )
                  ],
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    )),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                          style: TextStyle(wordSpacing: 2,color: Colors.black),
                          underline: SizedBox(),
                          isExpanded: true,
                          value: unitcode,
                          onChanged: (newValue){
                            setState(() {
                              unitcode=newValue;
                            });
                          },
                          items: listtype.map((item)  {
                            return DropdownMenuItem(
                                value: item,
                                child:Text("${item == 1? "الوحده الصغيره": "الوحده الكبيره"}")
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("الوحده"),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Container(

              )),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: RaisedButton(
                      color: Colors.lightGreen,
                      child: Text("ok",style: TextStyle(color: Colors.white),),
                      onPressed: (){
                        Navigator.pop(context, DialogModel(valueChose, unitcode));
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
  List<Items> _ItemsFilter(List<Items>  items){
    List<Items> items2=[];
    var set = new Set();
    for (Items it in items){
      if(!set.contains(it.storeCODE)){
        set.add(it.storeCODE);
        items2.add(it);
      }
    }
    return items2;
  }
}

class DialogModel {
  int _code;
  int _unit;

  DialogModel(this._code, this._unit);

  int get unit => _unit;

  set unit(int value) {
    _unit = value;
  }

  int get code => _code;

  set code(int value) {
    _code = value;
  }
}


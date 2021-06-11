
import 'package:flutter/foundation.dart';

class SettingProvieder with ChangeNotifier, DiagnosticableTreeMixin{
  String _ip;
  String _port;
  String _typePrice;
  String _diviceId;


  setDiviceID(String _diviceId){
     this._diviceId=_diviceId;
  }

  getDiviceId(){
    return this._diviceId;
  }

  setIP(String ip){
    _ip=ip;
    notifyListeners();
  }

  getIP(){
    return _ip;
  }


  setPort(String port ){
    _port = port;
    notifyListeners();
  }

  getPort(){
    return _port;
  }

  setTypePrice(String _typePrice ){
    _typePrice = _typePrice;
    notifyListeners();
  }

  getTypePrice(){
    return _typePrice;
  }



}
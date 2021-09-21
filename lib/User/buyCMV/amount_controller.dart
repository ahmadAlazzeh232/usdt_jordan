import 'dart:core';
import 'dart:math';
class AmountController {
  static String amountUsdtToJordan(String usdtString, int passDis){
     double _discount = 0 ;
      if(passDis == 0){
        _discount = 0;
      }
      else if(passDis == 1){
        _discount = 0.25;
      }
      else if(passDis == 2){
        _discount = 0.5 ;
      }


    double? UsdtDouble =double.tryParse(usdtString);
    double? _dinar = UsdtDouble!*0.71;


    late double _feeDinar ;
    late double _totalDinar ;
     late String _finalDinar;

     if(UsdtDouble<215 && usdtString != "" && !usdtString.isEmpty){
     double  _disFirst = 3* _discount;
       _feeDinar =3 - _disFirst ;
       _totalDinar =_dinar + _feeDinar;
       _finalDinar =_totalDinar.toStringAsFixed(2);
       return _finalDinar;

     }
     else if(UsdtDouble >= 215 && UsdtDouble <500){

    _feeDinar = (_dinar/100)*2;
    double _disSecond = _discount* _feeDinar ;
    _feeDinar = _feeDinar - _disSecond ;
    _totalDinar =_dinar + _feeDinar;
    _finalDinar =_totalDinar.toStringAsFixed(2);
    return _finalDinar;
     }
     else if(UsdtDouble >= 500 && UsdtDouble <750){
       _feeDinar= (_dinar/100)*1.75;
       double _disThird = _discount * _feeDinar ;
       _feeDinar =_feeDinar - _disThird;
       _totalDinar =_dinar + _feeDinar;
       _finalDinar =_totalDinar.toStringAsFixed(2);
       return _finalDinar;
     }
     else if(UsdtDouble >= 750 && UsdtDouble <= 1000){
       _feeDinar =(_dinar/100)*1.5;
       double _disFourth = _feeDinar * _discount ;
       _feeDinar = _feeDinar - _disFourth ;
       _totalDinar =_dinar + _feeDinar;
       _finalDinar =_totalDinar.toStringAsFixed(2);
       return _finalDinar;     }
     else if (UsdtDouble >1000){
       String _string = "السقف الأعلى 1000";
       return _string;}

     else {
       return "??" ;
     }
  }







  // static String amountDinarToUsdt(String DinarString){
  //
  //   double _dinarAmount = double.parse(DinarString);
  //    double _feeAmount = (_dinarAmount/100)*3;
  //
  //    if(_feeAmount<2.5){
  //      _feeAmount =2.5;
  //    double _totalDinar= _dinarAmount - _feeAmount;
  //    double _totalUsdt= _totalDinar/0.71 ;
  //    int _num = _totalUsdt.ceil();
  //    if(_num>700){
  //
  //    }
  //    String _result = _num.toString();
  //      return _result;
  //    }else{
  //      double _totalDinar= _dinarAmount - _feeAmount;
  //      double _totalUsdt= _totalDinar/0.71 ;
  //      int _num = _totalUsdt.ceil();
  //      String _result = _num.toString();
  //       return _result;
  //    }
  // }

}
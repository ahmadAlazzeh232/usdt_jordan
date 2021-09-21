class AmountSellController {

  static String UsdtSubtract(String usdtAmount) {
    late String _usdtSubtract;
    double _usdtNum = double.parse(usdtAmount);
    if (_usdtNum > 3.0 &&
        _usdtNum <  500) {
      double _finalUsdt = _usdtNum - 3;
      _usdtSubtract = _finalUsdt.toString();
      return _usdtSubtract;
    }
    else if(_usdtNum >= 500 && _usdtNum <= 1000) {
      double _finalUsdt = _usdtNum - 2;
      _usdtSubtract = _finalUsdt.toString();
      return _usdtSubtract;
    }else
      {return "الرقم خارج النطاق ";}
  }
  static String moneyValue(String usdtDis){
      late String _moneyFinal ;
      if(double.tryParse(usdtDis)!= null ){
        double _sdtNum = double.parse(usdtDis);
        double _money = _sdtNum * 0.709;
         _moneyFinal =_money.toStringAsFixed(2);
        return _moneyFinal;
      }else{
        return "الرقم خارج النطاق";
      }



  }
}


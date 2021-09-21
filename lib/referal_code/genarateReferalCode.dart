
import 'dart:math';


class GenerateReferalCode{

  static String getNesReferalCode(String name ,  ){
     List<String> smallLetter =['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q',
      'r','s','t','u','v','w','x','y','z'];
      List<String> bothSmallLetters = ['az','by','cx','dw','ev','fu','gt','hs','ir','jq','kp','lo','mn','nm','ol','pk','qj',
        'ri','sh','tg','uf','ve','wd','xc','yb','za'];
    List<String> CapitalLetters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q',
      'R','S','T','U','V','W','X','Y','Z'];
    List<String> letters = ['aB','bC','cD','dE','eF','fG','gH','hI','iJ','jK','kL','lM','mN','nO','oP','pQ','qR',
      'rS','sT','tU','uV','vW','wX','xY','yZ','zA'];
      int _firstRandom =   Random().nextInt(smallLetter.length-1);
     int _secondRandom =   Random().nextInt(bothSmallLetters.length-1);
     int _thirdRandom =   Random().nextInt(CapitalLetters.length-1);
     int _forthRandom =   Random().nextInt(letters.length-1);
     int _fifthRandom =   Random().nextInt(1000) +101;
     int _sixthRandom =   Random().nextInt(100);
    int _sevenRandom = Random().nextInt(500);
    int _eightRandom = Random().nextInt(20) +1 ;
     int _nineRandom = Random().nextInt(30) +1 ;
     String _firstChar = name.toString().trim();

     int _reLettersRAndom =   Random().nextInt(letters.length-1);
     int _reBothLetters = Random().nextInt(bothSmallLetters.length-1);




   String _lastCode = _firstChar+ smallLetter[_firstRandom] + bothSmallLetters[_secondRandom] + CapitalLetters[_thirdRandom]
     + letters[_forthRandom] +(_fifthRandom - _sixthRandom).toString() + (_eightRandom * _nineRandom).toString() +
       _sevenRandom.toString() + bothSmallLetters[_reBothLetters]+ letters[_reLettersRAndom];
     return _lastCode ;
   }
}
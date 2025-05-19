import 'dart:math';

class RandomTextModel {
  static final List<String> _texts = [
    '＼ｵﾚはｱﾗﾝだ／',
    '＼ｱﾗﾝﾁｭｰﾘﾝｸﾞをｿﾝｹｲｼﾃﾏｽﾖ／',
    '＼ｴﾄﾞｶﾞｰ･ｱﾗﾝ･ﾎﾟｰが元ﾈﾀﾃﾞｽﾖ!／',
    '＼ﾆｯﾁｪｱｲｼﾃﾏｽﾖ!／',
    '＼ｳｯ!／'
  ];
  final Random _random = Random();

  String getRandomText() {
    return _texts[_random.nextInt(_texts.length)];
  }
}

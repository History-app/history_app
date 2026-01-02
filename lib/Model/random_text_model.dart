import 'dart:math';

class RandomTextModel {
  static final List<String> _texts = [
    '＼ﾏｽｺｯﾄのｱﾗﾝﾃﾞｽﾖ／',
    '＼ﾎﾞｸは日本史のﾖｳｾｲﾃﾞｽﾖ／',
    '＼ｴﾄﾞｶﾞｰ･ｱﾗﾝ･ﾎﾟｰが元ﾈﾀﾃﾞｽﾖ!／',
    '＼ﾋﾋﾞのﾂﾐｶｻﾈがﾀﾞｲｼﾞﾃﾞｽﾖ／',
    '＼ﾍﾞﾝｷｮｳがんばりﾏｽﾖ／'
  ];
  final Random _random = Random();

  String getRandomText() {
    return _texts[_random.nextInt(_texts.length)];
  }
}

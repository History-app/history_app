const List<String> kEras = [
  '旧石器',
  '縄文',
  '弥生',
  '古墳',
  '飛鳥',
  '奈良',
  '平安',
  '鎌倉',
  '南北朝',
  '室町',
  '戦国',
  '江戸',
  '江戸後期',
  '江戸幕末',
  '明治',
  '大正',
  '昭和戦前',
  // '平成',
  // '令和',
];
const Map<String, int> eraStartNumbers = {
  '旧石器': 1,
  '縄文': 22,
  '弥生': 53,
  '古墳': 137,
  '飛鳥': 251,
  '奈良': 456,
  '平安': 637,
  '鎌倉': 863,
  '南北朝': 1177,
  '室町': 1238,
  '戦国': 1503,
  '江戸': 1713,
  '江戸後期': 2270,
  '江戸幕末': 2443,
  '明治': 2576,
  '大正': 2868,
  '昭和戦前': 3069,

  // ...残りを設定
};

int eraIndexOf(String label) => kEras.indexOf(label);
String eraLabelAt(int index) => (index >= 0 && index < kEras.length) ? kEras[index] : '';

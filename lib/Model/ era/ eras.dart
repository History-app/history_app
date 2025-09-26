const List<String> kEras = [
  '旧石器',
  '縄文',
  '弥生',
  '古墳',
  '飛鳥',
  '奈良',
  '平安',
  // '鎌倉',
  // '室町',
  // '安土桃山',
  // '江戸',
  // '明治',
  // '大正',
  // '昭和',
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
  // ...残りを設定
};

int eraIndexOf(String label) => kEras.indexOf(label);
String eraLabelAt(int index) => (index >= 0 && index < kEras.length) ? kEras[index] : '';

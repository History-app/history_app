/// 利用する場合は以下を記載
/// import 'package:japanese_history_app/util/number_formatter.dart';

extension IntExt on int {
  int toPercent() => this;

  double toPercentOf(int total) {
    if (total == 0) return 0.0;
    return (this / total).clamp(0.0, 1.0);
  }
}

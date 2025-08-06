import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Model/random_text_model.dart';

final randomTextProvider = StateNotifierProvider<RandomTextViewModel, String>(
  (ref) => RandomTextViewModel(),
);

class RandomTextViewModel extends StateNotifier<String> {
  final RandomTextModel _model = RandomTextModel();

  RandomTextViewModel() : super('ここに表示されます');

  void generateRandomText() {
    state = _model.getRandomText();
  }
}

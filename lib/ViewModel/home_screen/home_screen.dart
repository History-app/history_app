import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/card_provider.dart';
import '../../repositories/config_repository.dart';

final homescreenProvider = Provider<HomeScreenViewModel>((ref) {
  return HomeScreenViewModel(ref);
});

class HomeScreenViewModel {
  final Ref ref;

  HomeScreenViewModel(this.ref);

  Future<void> fetchUsersMultipleCards(List<String> noteRefs) async {
    await ref
        .read(cardsDataNewNotifierProvider.notifier)
        .fetchUsersMultipleCards(noteRefs);
  }

  Future getNotesByNoteRef(String noteRefs) async {
    final notesData = await ref
        .read(cardsDataNewNotifierProvider.notifier)
        .getNotesByNoteRef(noteRefs);
    return notesData;
  }

  Future<void> updateNotes(List<Map<String, dynamic>> allNotes) async {
    ref.read(cardsDataNewNotifierProvider.notifier).updateNotes(allNotes);
  }

  void updateLeftValueDistribution(duecards) {
    Map<dynamic, int> distribution = {};

    for (var card in duecards) {
      if (card.containsKey('left')) {
        final leftValue = card['left'];
        distribution[leftValue] = (distribution[leftValue] ?? 0) + 1;
      }
    }
    ref
        .read(cardsDataNewNotifierProvider.notifier)
        .updateLeftValueDistribution(distribution);
  }

  Future<bool> checkCurrentVersion() async {
    return await ref.read(configRepositoryProvider).versionCheck();
  }
}

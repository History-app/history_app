import 'package:freezed_annotation/freezed_annotation.dart';

part 'cards_data_state.freezed.dart';

@freezed
class CardsDataState with _$CardsDataState {
  const factory CardsDataState({
    @Default([]) List<Map<String, dynamic>> cards,
    @Default([]) List<String> todaysReviewNoteRefs,
    @Default([]) List<Map<String, dynamic>> usersMultipleCards,
    @Default([]) List<Map<String, dynamic>> notesByNoteRef,
    @Default([]) List<Map<String, dynamic>> allNotes,
    @Default({}) Map<dynamic, int> leftValueDistribution,
    @Default([]) List<Map<String, dynamic>> allLearnedCards,
    @Default(0) int newCardCount,
    @Default(0) int learningCardCount,
    @Default(0) int reviewCardCount,
    @Default(0) int totalCardCount,
  }) = _CardsDataState;
}

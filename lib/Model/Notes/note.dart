import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required List<String> flds, // 文字列のリスト
    required String sfld, // 必須の文字列
  }) = _Note;
}

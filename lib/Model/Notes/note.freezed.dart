// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Note {
  List<String> get flds => throw _privateConstructorUsedError; // 文字列のリスト
  String get sfld => throw _privateConstructorUsedError;

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteCopyWith<Note> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteCopyWith<$Res> {
  factory $NoteCopyWith(Note value, $Res Function(Note) then) =
      _$NoteCopyWithImpl<$Res, Note>;
  @useResult
  $Res call({List<String> flds, String sfld});
}

/// @nodoc
class _$NoteCopyWithImpl<$Res, $Val extends Note>
    implements $NoteCopyWith<$Res> {
  _$NoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flds = null,
    Object? sfld = null,
  }) {
    return _then(_value.copyWith(
      flds: null == flds
          ? _value.flds
          : flds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sfld: null == sfld
          ? _value.sfld
          : sfld // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoteImplCopyWith<$Res> implements $NoteCopyWith<$Res> {
  factory _$$NoteImplCopyWith(
          _$NoteImpl value, $Res Function(_$NoteImpl) then) =
      __$$NoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> flds, String sfld});
}

/// @nodoc
class __$$NoteImplCopyWithImpl<$Res>
    extends _$NoteCopyWithImpl<$Res, _$NoteImpl>
    implements _$$NoteImplCopyWith<$Res> {
  __$$NoteImplCopyWithImpl(_$NoteImpl _value, $Res Function(_$NoteImpl) _then)
      : super(_value, _then);

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flds = null,
    Object? sfld = null,
  }) {
    return _then(_$NoteImpl(
      flds: null == flds
          ? _value._flds
          : flds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sfld: null == sfld
          ? _value.sfld
          : sfld // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NoteImpl implements _Note {
  const _$NoteImpl({required final List<String> flds, required this.sfld})
      : _flds = flds;

  final List<String> _flds;
  @override
  List<String> get flds {
    if (_flds is EqualUnmodifiableListView) return _flds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_flds);
  }

// 文字列のリスト
  @override
  final String sfld;

  @override
  String toString() {
    return 'Note(flds: $flds, sfld: $sfld)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteImpl &&
            const DeepCollectionEquality().equals(other._flds, _flds) &&
            (identical(other.sfld, sfld) || other.sfld == sfld));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_flds), sfld);

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteImplCopyWith<_$NoteImpl> get copyWith =>
      __$$NoteImplCopyWithImpl<_$NoteImpl>(this, _$identity);
}

abstract class _Note implements Note {
  const factory _Note(
      {required final List<String> flds,
      required final String sfld}) = _$NoteImpl;

  @override
  List<String> get flds; // 文字列のリスト
  @override
  String get sfld;

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteImplCopyWith<_$NoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

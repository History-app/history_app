// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Note {
  List<String> get flds => throw _privateConstructorUsedError; // 文字列のリスト
  String get sfld => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
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
abstract class _$$_NoteCopyWith<$Res> implements $NoteCopyWith<$Res> {
  factory _$$_NoteCopyWith(_$_Note value, $Res Function(_$_Note) then) =
      __$$_NoteCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> flds, String sfld});
}

/// @nodoc
class __$$_NoteCopyWithImpl<$Res> extends _$NoteCopyWithImpl<$Res, _$_Note>
    implements _$$_NoteCopyWith<$Res> {
  __$$_NoteCopyWithImpl(_$_Note _value, $Res Function(_$_Note) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flds = null,
    Object? sfld = null,
  }) {
    return _then(_$_Note(
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

class _$_Note implements _Note {
  const _$_Note({required final List<String> flds, required this.sfld})
      : _flds = flds;

  final List<String> _flds;
  @override
  List<String> get flds {
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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Note &&
            const DeepCollectionEquality().equals(other._flds, _flds) &&
            (identical(other.sfld, sfld) || other.sfld == sfld));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_flds), sfld);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NoteCopyWith<_$_Note> get copyWith =>
      __$$_NoteCopyWithImpl<_$_Note>(this, _$identity);
}

abstract class _Note implements Note {
  const factory _Note(
      {required final List<String> flds, required final String sfld}) = _$_Note;

  @override
  List<String> get flds;
  @override // 文字列のリスト
  String get sfld;
  @override
  @JsonKey(ignore: true)
  _$$_NoteCopyWith<_$_Note> get copyWith => throw _privateConstructorUsedError;
}

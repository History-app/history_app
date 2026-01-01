// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'studying_note_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StudyingNoteState {
  bool get isLoading => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of StudyingNoteState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudyingNoteStateCopyWith<StudyingNoteState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudyingNoteStateCopyWith<$Res> {
  factory $StudyingNoteStateCopyWith(
    StudyingNoteState value,
    $Res Function(StudyingNoteState) then,
  ) = _$StudyingNoteStateCopyWithImpl<$Res, StudyingNoteState>;
  @useResult
  $Res call({bool isLoading, String? imageUrl, String? errorMessage});
}

/// @nodoc
class _$StudyingNoteStateCopyWithImpl<$Res, $Val extends StudyingNoteState>
    implements $StudyingNoteStateCopyWith<$Res> {
  _$StudyingNoteStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudyingNoteState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? imageUrl = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudyingNoteStateImplCopyWith<$Res>
    implements $StudyingNoteStateCopyWith<$Res> {
  factory _$$StudyingNoteStateImplCopyWith(
    _$StudyingNoteStateImpl value,
    $Res Function(_$StudyingNoteStateImpl) then,
  ) = __$$StudyingNoteStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, String? imageUrl, String? errorMessage});
}

/// @nodoc
class __$$StudyingNoteStateImplCopyWithImpl<$Res>
    extends _$StudyingNoteStateCopyWithImpl<$Res, _$StudyingNoteStateImpl>
    implements _$$StudyingNoteStateImplCopyWith<$Res> {
  __$$StudyingNoteStateImplCopyWithImpl(
    _$StudyingNoteStateImpl _value,
    $Res Function(_$StudyingNoteStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudyingNoteState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? imageUrl = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$StudyingNoteStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$StudyingNoteStateImpl implements _StudyingNoteState {
  const _$StudyingNoteStateImpl({
    this.isLoading = true,
    this.imageUrl,
    this.errorMessage,
  });

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? imageUrl;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'StudyingNoteState(isLoading: $isLoading, imageUrl: $imageUrl, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudyingNoteStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, imageUrl, errorMessage);

  /// Create a copy of StudyingNoteState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudyingNoteStateImplCopyWith<_$StudyingNoteStateImpl> get copyWith =>
      __$$StudyingNoteStateImplCopyWithImpl<_$StudyingNoteStateImpl>(
        this,
        _$identity,
      );
}

abstract class _StudyingNoteState implements StudyingNoteState {
  const factory _StudyingNoteState({
    final bool isLoading,
    final String? imageUrl,
    final String? errorMessage,
  }) = _$StudyingNoteStateImpl;

  @override
  bool get isLoading;
  @override
  String? get imageUrl;
  @override
  String? get errorMessage;

  /// Create a copy of StudyingNoteState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudyingNoteStateImplCopyWith<_$StudyingNoteStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

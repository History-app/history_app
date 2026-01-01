// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  uid: json['uid'] as String,
  nullCount: (json['nullCount'] as num?)?.toInt() ?? 5,
  startEra: json['startEra'] as String? ?? "旧石器",
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'nullCount': instance.nullCount,
      'startEra': instance.startEra,
    };

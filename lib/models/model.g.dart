// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Model _$ModelFromJson(Map<String, dynamic> json) => Model(
      format: json['format'] as String,
      family: json['family'] as String,
      families: (json['families'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      parameter_size: json['parameter_size'] as String,
      quantization_level: json['quantization_level'] as String,
    );

Map<String, dynamic> _$ModelToJson(Model instance) {
  final val = <String, dynamic>{
    'format': instance.format,
    'family': instance.family,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('families', instance.families);
  val['parameter_size'] = instance.parameter_size;
  val['quantization_level'] = instance.quantization_level;
  return val;
}

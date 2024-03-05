// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Model _$ModelFromJson(Map<String, dynamic> json) => Model(
      name: json['name'] as String,
      format: json['format'] as String,
      family: json['family'] as String,
      families:
          (json['families'] as List<dynamic>).map((e) => e as String).toList(),
      parameter_size: json['parameter_size'] as String,
      quantization_level: json['quantization_level'] as String,
    );

Map<String, dynamic> _$ModelToJson(Model instance) => <String, dynamic>{
      'name': instance.name,
      'format': instance.format,
      'family': instance.family,
      'families': instance.families,
      'parameter_size': instance.parameter_size,
      'quantization_level': instance.quantization_level,
    };

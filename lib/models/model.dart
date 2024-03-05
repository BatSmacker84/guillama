// AI Model Data Class
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class Model {
  final String name;
  final String format;
  final String family;
  final List<String> families;
  final String parameter_size;
  final String quantization_level;

  Model({
    required this.name,
    required this.format,
    required this.family,
    required this.families,
    required this.parameter_size,
    required this.quantization_level,
  });

  factory Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

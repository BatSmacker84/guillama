// AI Model Data Class
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable(includeIfNull: false)
class Model {
  final String format;
  final String family;
  final List<String>? families;
  final String parameter_size;
  final String quantization_level;

  @JsonKey(includeFromJson: false)
  String? name;
  @JsonKey(includeFromJson: false)
  String? tag;

  Model({
    required this.format,
    required this.family,
    this.families,
    required this.parameter_size,
    required this.quantization_level,
    this.name,
    this.tag,
  });

  factory Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

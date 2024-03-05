// AI Message Data Class
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final String role;
  final String content;

  @JsonKey(includeIfNull: false)
  final List<String>? images;

  Message({
    required this.role,
    required this.content,
    this.images,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

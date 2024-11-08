import 'package:json_annotation/json_annotation.dart';

part 'result.g.dart';

@JsonSerializable()
class Result {
  String? title;
  String? button;

  Result({this.title, this.button});

  // A necessary factory constructor for creating a new Result instance
  // from a map. Pass the map to the generated `_$ResultFromJson()` constructor.
  // The constructor is named after the source class, in this case, Result.
  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  // A necessary method which converts this class to a map.
  // Pass the map to the generated `_$ResultToJson()` method.
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

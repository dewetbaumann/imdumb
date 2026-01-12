import 'package:imdumb/domain/models/entities/cast.dart';

class CastModel extends Cast {
  CastModel({required super.id, required super.name, required super.profilePath, required super.character});

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      id: json['id'],
      name: json['name'] ?? '',
      profilePath: json['profile_path'] ?? '',
      character: json['character'] ?? '',
    );
  }
}

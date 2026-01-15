import 'package:pluto_ui/constants/strings.dart';

class ApartmentModel {
  final int id;
  final String governorate;
  final String city;
  final double rate;
  final String photo;
  bool isFavorite;
  final String? price;
  final int? area;
  final int? rooms;
  final int? floor;
  final String? description;

  ApartmentModel({
    required this.id,
    required this.governorate,
    required this.city,
    required this.rate,
    required this.photo,
    required this.isFavorite,
    // Detail fields are optional/nullable in the constructor
    this.price,
    this.area,
    this.rooms,
    this.floor,
    this.description,
  });

  // Getter to fix the image URL for mobile testing, replacing local IP with
  String get imageUrl {
    return photo.replaceFirst('http://127.0.0.1:8000', 'http://$localIp:8000');
  }

  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    return ApartmentModel(
      //  Using safe parsing logic
      id: int.parse(json['id'].toString()),
      governorate: json['governorate'] as String,
      city: json['city'] as String,
      rate: double.parse(json['rate'].toString()),
      photo: json['photo'] as String,
      isFavorite: bool.parse(json['isFavourite'].toString()),
      price: json['price']?.toString(),

      area: json['area'] != null ? int.tryParse(json['area'].toString()) : null,
      rooms: json['rooms'] != null
          ? int.tryParse(json['rooms'].toString())
          : null,
      floor: json['floor'] != null
          ? int.tryParse(json['floor'].toString())
          : null,

      description: json['description'] as String?,
    );
  }

  ApartmentModel copyWith({
    int? id,
    String? governorate,
    String? city,
    double? rate,
    String? photo,
    bool? isFavorite,
    String? price,
    int? area,
    int? rooms,
    int? floor,
    String? description,
  }) {
    return ApartmentModel(
      id: id ?? this.id,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      rate: rate ?? this.rate,
      photo: photo ?? this.photo,
      isFavorite: isFavorite ?? this.isFavorite,
      price: price ?? this.price,
      area: area ?? this.area,
      rooms: rooms ?? this.rooms,
      floor: floor ?? this.floor,
      description: description ?? this.description,
    );
  }
}

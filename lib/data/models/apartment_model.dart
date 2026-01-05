import 'package:pluto_ui/constants/strings.dart';
import 'package:pluto_ui/data/models/profile_model.dart';

class ApartmentModel {
  // ----------------------------------------------------
  // COMMON FIELDS (Present in both List and Detail responses)
  // ----------------------------------------------------
  final int id;
  final String governorate;
  final String city;
  final double rate;
  final String photo;

  // Local State Field (Not from API)
  bool isFavorite;

  // ----------------------------------------------------
  // DETAIL-SPECIFIC FIELDS (Must be Nullable for the List response)
  // ----------------------------------------------------
  final String? price;
  final int? area;
  final int? rooms;
  final int? floor;
  final String? description;
  // ProfileModel? profile;
  // ----------------------------------------------------
  // CONSTRUCTOR
  // ----------------------------------------------------
  ApartmentModel({
    required this.id,
    required this.governorate,
    required this.city,
    required this.rate,
    required this.photo,
    this.isFavorite = false, // Default value for local state
    // Detail fields are optional/nullable in the constructor
    this.price,
    this.area,
    this.rooms,
    this.floor,
    this.description,
    // this.profile,
  });

  // ----------------------------------------------------
  // GETTERS
  // ----------------------------------------------------
  /// Getter to fix the image URL for mobile testing, replacing local IP with
  /// the one accessible from the emulator/device.
  String get imageUrl {
    // Note: Using 192.168.1.109 as the replacement IP.
    // For Android Emulator, 10.0.2.2 is usually used if not using your local IP.
    return photo.replaceFirst('http://127.0.0.1:8000', 'http://$localIp:8000');
  }

  // ----------------------------------------------------
  // FACTORY CONSTRUCTOR (JSON Deserialization)
  // ----------------------------------------------------
  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    return ApartmentModel(
      // Common fields: Using safe parsing logic
      id: int.parse(json['id'].toString()),
      governorate: json['governorate'] as String,
      city: json['city'] as String,
      // Rate needs to be parsed as double, handling potential int inputs safely
      rate: double.parse(json['rate'].toString()),
      photo: json['photo'] as String,
      isFavorite: false, // Always initialize local state to default
      // Detail-specific fields: Safely handle missing keys (which return null)
      price: json['price']?.toString(),

      // Area and Rooms: Safely parse to int?, handling potential nulls
      area: json['area'] != null ? int.tryParse(json['area'].toString()) : null,
      rooms: json['rooms'] != null
          ? int.tryParse(json['rooms'].toString())
          : null,
      floor: json['floor'] != null
          ? int.tryParse(json['floor'].toString())
          : null,

      // Description: Safely cast (it's often a string or null)
      description: json['description'] as String?,
      // profile: ProfileModel.fromJson(json['profile']),
    );
  }

  // ----------------------------------------------------
  // COPYWITH METHOD (State Management Helper)
  // ----------------------------------------------------
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

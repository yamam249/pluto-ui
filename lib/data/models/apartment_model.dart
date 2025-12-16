// class ApartmentModel {
//   final int id;
//   final String governorate;
//   final String city;
//   final double rate;
//   final String photo;
//   // 🛑 ADDED: Property to hold local state managed by the app/cubit
//   final bool isFavorite;

//   ApartmentModel({
//     required this.id,
//     required this.governorate,
//     required this.city,
//     required this.rate,
//     required this.photo,
//     this.isFavorite =
//         false, // Default is false unless marked otherwise by app logic
//   });
//   // 🛑 ADDED: A getter to fix the image URL for mobile testing
//   String get imageUrl {
//     // If the URL starts with localhost (127.0.0.1), replace it with the
//     // Android Emulator's loopback IP (10.0.2.2) so the device can access the host machine.
//     return photo.replaceFirst(
//       'http://127.0.0.1:8000',
//       'http://192.168.1.109:8000',
//     );
//   }

//   factory ApartmentModel.fromJson(Map<String, dynamic> json) {
//     // Handle potential null/dynamic types and casting
//     return ApartmentModel(
//       // id: json['id'] as int,
//       id: int.parse(json['id'].toString()),
//       governorate: json['governorate'] as String,
//       city: json['city'] as String,
//       // The rate can be an int (0) or a double (2.5), so cast it dynamically to a double
//       // rate: (json['rate'] as num).toDouble(),
//       rate: double.parse(json['rate'].toString()),
//       photo: json['photo'] as String,
//       // We assume the API does NOT return isFavorite, so we initialize it locally
//       isFavorite: false,
//     );
//   }
//   // 💡 HELPER: Method for Cubit to create a copy with toggled favorite status
//   ApartmentModel copyWith({
//     int? id,
//     String? governorate,
//     String? city,
//     double? rate,
//     String? photo,
//     bool? isFavorite,
//   }) {
//     return ApartmentModel(
//       id: id ?? this.id,
//       governorate: governorate ?? this.governorate,
//       city: city ?? this.city,
//       rate: rate ?? this.rate,
//       photo: photo ?? this.photo,
//       isFavorite: isFavorite ?? this.isFavorite,
//     );
//   }
// }

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
  final bool isFavorite;

  // ----------------------------------------------------
  // DETAIL-SPECIFIC FIELDS (Must be Nullable for the List response)
  // ----------------------------------------------------
  final String? price;
  final int? area;
  final int? rooms;
  final int? floor;
  final String? description;

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
  });

  // ----------------------------------------------------
  // GETTERS
  // ----------------------------------------------------
  /// Getter to fix the image URL for mobile testing, replacing local IP with
  /// the one accessible from the emulator/device.
  String get imageUrl {
    // Note: Using 192.168.1.109 as the replacement IP.
    // For Android Emulator, 10.0.2.2 is usually used if not using your local IP.
    return photo.replaceFirst(
      'http://127.0.0.1:8000',
      'http://192.168.1.109:8000',
    );
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

class PostApartmentModel {
  final int cityId;
  final int area;
  final int rooms;
  final String description;
  final String photo;
  final int price;
  final int floor;

  PostApartmentModel({
    required this.cityId,
    required this.area,
    required this.rooms,
    required this.description,
    required this.photo,
    required this.price,
    required this.floor,
  });

  Map<String, dynamic> toJson() {
    return {
      'city_id': cityId,
      'area': area,
      'rooms': rooms,
      'description': description,
      'photo': photo,
      'price': price,
      'floor': floor,
    };
  }
}

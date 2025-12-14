// lib/data/models/place_model.dart

class PlaceModel {
final String imagePath;
final String location;
final double rating;
bool isFavorite; // ✅ تمت الإضافة

PlaceModel({
required this.imagePath,
required this.location,
required this.rating,
this.isFavorite = false, // ✅ القيمة الافتراضية
});
}
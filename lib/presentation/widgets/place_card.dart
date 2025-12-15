import 'package:flutter/material.dart';
import 'package:pluto_ui/data/models/place_model.dart';
import 'package:pluto_ui/constants/app_colors.dart';

class PlaceCard extends StatefulWidget {
  final PlaceModel place;
  final bool isDark;

  const PlaceCard({
    super.key,
    required this.place,
    required this.isDark,
  });

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    int full = rating.floor();
    bool half = (rating - full) >= 0.5;

    for (int i = 0; i < 5; i++) {
      if (i < full) {
        stars.add(Icon(Icons.star, color: kPrimaryColor, size: 16));
      } else if (i == full && half) {
        stars.add(Icon(Icons.star_half, color: kPrimaryColor, size: 16));
      } else {
        stars.add(Icon(Icons.star_border, color: AppColors.bgActive(widget.isDark), size: 16));
      }
    }
    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    final bgCard = AppColors.bgCard(widget.isDark);
    final fontColor = AppColors.fontColor(widget.isDark);
    final subColor = AppColors.subFontColor(widget.isDark);

    return Card(
      color: bgCard,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(widget.place.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    widget.place.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.place.isFavorite
                        ? AppColors.danger(widget.isDark)

                        : AppColors.bgActive(widget.isDark),
                  ),
                  onPressed: () {
                    setState(() {
                      widget.place.isFavorite = !widget.place.isFavorite;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Location", style: TextStyle(color: subColor, fontSize: 14)),
                    Text(widget.place.location,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: fontColor)),
                  ],
                ),
                _buildRatingStars(widget.place.rating),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

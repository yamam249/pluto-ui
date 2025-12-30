import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/presentation/screens/rating_screen.dart';
import 'package:pluto_ui/presentation/screens/edit_request_screen.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';

class HistoryScreen extends StatefulWidget {
  final bool isDark;
  const HistoryScreen({super.key, required this.isDark});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<Map<String, dynamic>> houses;

  @override
  void initState() {
    super.initState();
    houses = [
      {"name": "Luxury Villa", "date": "2024-03-10", "status": "pending", "isRated": false},
      {"name": "Modern Apartment", "date": "2024-04-18", "status": "accepted", "isRated": false},
      {"name": "Family House", "date": "2024-05-22", "status": "rejected", "isRated": false},
      {"name": "Studio Flat", "date": "2024-06-01", "status": "renting", "isRated": false},
      {"name": "Damascus Home", "date": "2024-07-12", "status": "completed", "isRated": false},
    ];
  }

  void _showDeleteDialog(String name, Color cardColor, Color fontColor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Cancel Request", style: TextStyle(color: fontColor, fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to cancel the request for $name?", style: TextStyle(color: fontColor.withOpacity(0.8))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("No", style: TextStyle(color: AppColors.subFontColor(widget.isDark)))),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$name Canceled"), backgroundColor: AppColors.kColorDanger));
            },
            child: const Text("Yes, Cancel", style: TextStyle(color: AppColors.kColorDanger, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain(widget.isDark),
      appBar: AppBar(
        title: const Text("Rental History", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.bgCard(widget.isDark),
        foregroundColor: AppColors.fontColor(widget.isDark),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: houses.length,
        itemBuilder: (context, i) {
          final house = houses[i];
          final status = house["status"];
          final isRated = house["isRated"];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.bgCard(widget.isDark),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary(widget.isDark).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.home_work_rounded, color: AppColors.primary(widget.isDark)),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(house["name"], style: TextStyle(color: AppColors.fontColor(widget.isDark), fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text("Request Date: ${house["date"]}", style: TextStyle(color: AppColors.subFontColor(widget.isDark), fontSize: 13)),
                          ],
                        ),
                      ),
                      _buildStatusChip(status),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(thickness: 0.5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Actions", style: TextStyle(color: AppColors.subFontColor(widget.isDark), fontWeight: FontWeight.w500)),
                      _buildActionButtons(house, i),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;
    switch (status) {
      case 'accepted': color = AppColors.kColorSuccess; text = "Agreed"; break;
      case 'rejected': color = AppColors.kColorDanger; text = "Rejected"; break;
      case 'completed': color = const Color(0xFF3B82F6); text = "Done"; break;
      case 'renting': color = Colors.orange; text = "Living"; break;
      default: color = AppColors.kBgActive; text = "Pending";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> house, int index) {
    if (house["status"] == 'accepted') {
      return Row(
        children: [
          _iconAction(Icons.edit_note_rounded, AppColors.primary(widget.isDark), () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditRequestScreen(isDark: widget.isDark, houseName: house["name"], initialDate: house["date"])));
          }),
          const SizedBox(width: 10),
          _iconAction(Icons.delete_outline_rounded, AppColors.kColorDanger, () => _showDeleteDialog(house["name"], AppColors.bgCard(widget.isDark), AppColors.fontColor(widget.isDark))),
        ],
      );
    } else if (house["status"] == 'completed') {
      return house["isRated"]
          ? Icon(Icons.verified_rounded, color: AppColors.kColorSuccess)
          : ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary(widget.isDark),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => RatingScreen(isDark: widget.isDark, apartmentModel: ApartmentModel(id:1, governorate:"Syr", city: house["name"], photo:"", price:"", rate:4.5, area:1, rooms:1, floor:1, description:""))));
          setState(() => house["isRated"] = true);
        },
        child: const Text("Rate Now", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      );
    }
    return Text("--", style: TextStyle(color: AppColors.subFontColor(widget.isDark)));
  }

  Widget _iconAction(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
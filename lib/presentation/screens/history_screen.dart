import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/app_colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, String>> houses = [
    {"name": "House in Damascus", "date": "2024-03-10"},
    {"name": "Apartment in Homs", "date": "2024-04-18"},
    {"name": "Villa in Latakia", "date": "2024-05-22"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgMain,
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: kBgCard,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: houses.length,
        itemBuilder: (context, i) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: Icon(Icons.house, size: 30, color: kPrimaryColor),
              title: Text(
                houses[i]["name"]!,
                style: TextStyle(
                  color: kFontColorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Rented on: ${houses[i]["date"]}",
                style: TextStyle(color: kFontColorDark.withOpacity(0.7)),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: kPrimaryColor),
                    onPressed: () => editHouse(context, i),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: kColorDanger),
                    onPressed: () => deleteHouse(context, i),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void editHouse(BuildContext context, int index) {
    TextEditingController controller =
    TextEditingController(text: houses[index]["date"]);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Rental Date"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Date",
            hintText: "YYYY-MM-DD",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                houses[index]["date"] = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void deleteHouse(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Rental"),
        content: const Text("Are you sure you want to delete this record?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                houses.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/apartment_cubit/cubit/apartment_cubit.dart';
import 'package:pluto_ui/presentation/screens/apartment_details_screen.dart';
import 'package:pluto_ui/presentation/widgets/place_card.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/presentation/screens/filter_page.dart';

class HomeScreen extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final apartmentCubit = context.read<ApartmentCubit>();

    final bgColor = AppColors.bgMain(isDark);
    final appBarColor = AppColors.bgCard(isDark);
    final fontColor = AppColors.fontColor(isDark);
    final subColor = AppColors.subFontColor(isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        // backgroundColor: kFontColorLight,
        backgroundColor: appBarColor,

        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text(
            //   'Pluto',
            //   style: TextStyle(
            //     color: kFontColorDark,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 24,
            //   ),
            // ),
            // IconButton(
            //   icon: Icon(Icons.filter_list, color: kFontColorDark),
            //   onPressed: () async {
            //     // Navigate and await the filter results (the Map<String, dynamic>)
            //     final Map<String, dynamic>? filters = await Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const FilterPage()),
            Text(
              'Pluto',
              style: TextStyle(
                color: fontColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            IconButton(
              icon: Icon(Icons.filter_list, color: fontColor),
              onPressed: () async {
                final Map<String, dynamic>? filters = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FilterPage(isDark: isDark)),
                );

                // Check if the user returned any filters
                if (filters != null) {
                  // Pass the received map directly to the Cubit's fetching method
                  apartmentCubit.fetchApartments(filters: filters);
                }
                // Note: If filters is null (user hit back), no action is taken.
              },
            ),
          ],
        ),
      ),

      body: BlocBuilder<ApartmentCubit, ApartmentState>(
        builder: (context, state) {
          if (state is ApartmentLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.kFontColorDark),
            );
          }
          if (state is ApartmentError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Error loading apartments: ${state.message}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.kColorDanger, fontSize: 16),
                ),
              ),
            );
          }
          if (state is ApartmentLoaded) {
            if (state.apartments.isEmpty) {
              return const Center(
                child: Text(
                  'No apartments found.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              itemCount: state.apartments.length,
              itemBuilder: (context, index) {
                final apartment = state.apartments[index];

                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ApartmentDetailsScreen(apartmentId: apartment.id),
                    ),
                  ),

                  child: PlaceCard(
                    place: apartment,
                    isDark: isDark,
                    // // 🛑 THE KEY CHANGE: Pass the callback function
                    // onFavoriteToggle: () {
                    //   _toggleFavorite(context, apartment);
                    // },
                  ),
                );
              },
            );
          }
          // Default/Initial State UI
          return const SizedBox.shrink(); // Hide everything until data starts loading

          // body: ListView.builder(
          //   padding: const EdgeInsets.all(16),
          //   itemCount: mockPlaces.length,
          //   itemBuilder: (context, index) {
          //     return Padding(
          //       padding: const EdgeInsets.only(bottom: 16),
          //       child: PlaceCard(
          //         place: mockPlaces[index],
          //         isDark: isDark,
          //       ),
          //     );
        },
      ),
    );
  }
}

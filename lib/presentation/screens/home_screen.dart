import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/apartment_cubit/cubit/apartment_cubit.dart';
import 'package:pluto_ui/presentation/screens/apartment_details_screen.dart';
import 'package:pluto_ui/presentation/widgets/place_card.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/presentation/screens/filter_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apartmentCubit = context.read<ApartmentCubit>();
    return Scaffold(
      backgroundColor: kBgMain,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kFontColorLight,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pluto',
              style: TextStyle(
                color: kFontColorDark,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            IconButton(
              icon: Icon(Icons.filter_list, color: kFontColorDark),
              onPressed: () async {
                // Navigate and await the filter results (the Map<String, dynamic>)
                final Map<String, dynamic>? filters = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FilterPage()),
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
              child: CircularProgressIndicator(color: kFontColorDark),
            );
          }
          if (state is ApartmentError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Error loading apartments: ${state.message}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kColorDanger, fontSize: 16),
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
        },
      ),
    );
  }
}

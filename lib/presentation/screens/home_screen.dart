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

      body: RefreshIndicator(
        color: AppColors.kFontColorDark,
        backgroundColor: AppColors.kBgMain,
        //color: AppColors.bgActive(isDark), // Customize the spinner color
        onRefresh: () async {
          // This calls the ApartmentCubit to fetch fresh data
          // We return the future so the spinner stays until the data is loaded
          await context.read<ApartmentCubit>().fetchApartments();
        },
        child: BlocBuilder<ApartmentCubit, ApartmentState>(
          builder: (context, state) {
            if (state is ApartmentLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.kFontColorDark,
                ),
              );
            }
            if (state is ApartmentError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Error loading apartments: ${state.message}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.kColorDanger,
                      fontSize: 16,
                    ),
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

              final sortedApartments = List.from(state.apartments)
                ..sort((a, b) => b.id.compareTo(a.id));

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: sortedApartments.length,
                itemBuilder: (context, index) {
                  final apartment = sortedApartments[index];

                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ApartmentDetailsScreen(apartmentId: apartment.id),
                      ),
                    ),

                    child: PlaceCard(place: apartment, isDark: isDark),
                  );
                },
              );
            } else {
              // Error or Initial state
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  const Center(child: Text("Pull down to try again")),
                ],
              );
            }

            // Default/Initial State UI
            // return const SizedBox.shrink(); // Hide everything until data starts loading
          },
        ),
      ),
    );
  }
}

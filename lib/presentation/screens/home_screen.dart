import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/apartment_cubit/cubit/apartment_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/presentation/screens/apartment_details_screen.dart';
import 'package:pluto_ui/presentation/widgets/place_card.dart';
import 'package:pluto_ui/presentation/screens/filter_page.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apartmentCubit = context.read<ApartmentCubit>();

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.cardColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pluto'.tr(),
              style: TextStyle(
                color: theme.primaryColor,

                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.filter_list,
                color: Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).primaryColor
                    : Colors.white,
              ),
              onPressed: () async {
                final Map<String, dynamic>? filters = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FilterPage()),
                );

                if (filters != null) {
                  apartmentCubit.fetchApartments(filters: filters);
                }
              },
            ),
          ],
        ),
      ),

      body: RefreshIndicator(
        color: theme.primaryColor,
        backgroundColor: theme.cardColor,
        onRefresh: () async {
          await context.read<ApartmentCubit>().fetchApartments();
        },
        child: BlocBuilder<ApartmentCubit, ApartmentState>(
          builder: (context, state) {
            if (state is ApartmentLoading) {
              return Center(
                child: CircularProgressIndicator(color: theme.primaryColor),
              );
            }
            if (state is ApartmentError) {
              print(state.message);

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      color: AppTheme.kColorDanger,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            }
            if (state is ApartmentLoaded) {
              if (state.apartments.isEmpty) {
                return Center(
                  child: Text(
                    'No apartments found.'.tr(),
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
                    child: PlaceCard(place: apartment),
                  );
                },
              );
            } else {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  Center(child: Text("Pull down to try again".tr())),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/apartment_details_cubit/cubit/apartment_details_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';
import 'package:pluto_ui/presentation/screens/booking_details_screen.dart';

class ApartmentDetailsScreen extends StatefulWidget {
  final int apartmentId;
  const ApartmentDetailsScreen({Key? key, required this.apartmentId})
    : super(key: key);

  @override
  State<ApartmentDetailsScreen> createState() => _ApartmentDetailsScreenState();
}

class _ApartmentDetailsScreenState extends State<ApartmentDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Get the Cubit and call the fetch method with the ID
    context.read<ApartmentDetailsCubit>().fetchApartmentDetails(
      widget.apartmentId,
    );
  }

  Widget buildSliverAppBar(ApartmentModel apartmentModel) {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      // backgroundColor: AppColors.kBgMain,

      // 1. CHANGE THIS COLOR: This is the background color of the bar when collapsed
      backgroundColor: AppColors.kBgCard,

      // 2. OPTIONAL: Add an iconTheme to ensure the back arrow is visible
      iconTheme: const IconThemeData(color: AppColors.kFontColorDark),
      flexibleSpace: FlexibleSpaceBar(
        // centerTitle: true,
        title: Text(
          // textAlign: TextAlign.center,
          '${apartmentModel.governorate}, ${apartmentModel.city}',
          style: TextStyle(
            color: AppColors.kFontColorDark,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Hero(
          tag: apartmentModel.id.toString(),
          child: Image.network(
            apartmentModel.imageUrl.toString(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  apartmentInfo(String title, String value) {
    return RichText(
      maxLines: 10,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              color: AppColors.kFontColorDark,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(color: AppColors.kFontColorDark, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget buildDivider(double endIndent) {
    return Divider(
      height: 30,
      endIndent: endIndent,
      color: AppColors.kFontColorLight,
      thickness: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kFontColorLight,
      body: BlocBuilder<ApartmentDetailsCubit, ApartmentDetailsState>(
        builder: (context, state) {
          if (state is ApartmentDetailsLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.kFontColorDark),
            );
          }

          if (state is ApartmentDetailsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Error loading details: ${state.message}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.kColorDanger, fontSize: 18),
                ),
              ),
            );
          }

          if (state is ApartmentDetailsLoaded) {
            final apartmentModel = state.apartment;
            return CustomScrollView(
              slivers: [
                buildSliverAppBar(apartmentModel),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          apartmentInfo(
                            'Governorate : ',
                            apartmentModel.governorate.toString(),
                          ),
                          buildDivider(150),

                          apartmentInfo(
                            'City : ',
                            apartmentModel.city.toString(),
                          ),
                          buildDivider(200),
                          apartmentInfo(
                            'Price(SYP) : ',
                            apartmentModel.price.toString(),
                          ),
                          buildDivider(100),
                          apartmentInfo(
                            'Area (sqm) : ',
                            apartmentModel.area.toString(),
                          ),
                          buildDivider(80),

                          apartmentInfo(
                            'Rooms : ',
                            apartmentModel.rooms.toString(),
                          ),
                          buildDivider(180),
                          apartmentInfo(
                            'floor : ',
                            apartmentModel.floor.toString(),
                          ),
                          buildDivider(180),
                          apartmentInfo(
                            'Description : ',
                            (apartmentModel.description ?? '').toString(),
                          ),
                          buildDivider(50),
                          apartmentInfo(
                            'rate : ',
                            (apartmentModel.rate ?? '').toString(),
                          ),
                          buildDivider(120),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(height: 600),
                  ]),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),

      // --- ADD THIS SECTION ---
      bottomNavigationBar: BlocBuilder<ApartmentDetailsCubit, ApartmentDetailsState>(
        builder: (context, state) {
          if (state is ApartmentDetailsLoaded) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.kBgMain, // Or any background color
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kFontColorDark,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Navigate to Booking Details
                  // Replace 'BookingDetailsScreen' with your actual class name
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookingDetailsScreen(apartment: state.apartment),
                    ),
                  );
                },
                child: const Text(
                  "Book Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink(); // Hide button while loading or error
        },
      ),
    );
  }
}

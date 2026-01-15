// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pluto_ui/business_logic/apartment_details_cubit/cubit/apartment_details_cubit.dart';
// import 'package:pluto_ui/constants/app_colors.dart';
// import 'package:pluto_ui/data/models/apartment_model.dart';
// import 'package:pluto_ui/presentation/screens/booking_details_screen.dart';

// class ApartmentDetailsScreen extends StatefulWidget {
//   final int apartmentId;
//   const ApartmentDetailsScreen({Key? key, required this.apartmentId})
//     : super(key: key);

//   @override
//   State<ApartmentDetailsScreen> createState() => _ApartmentDetailsScreenState();
// }

// class _ApartmentDetailsScreenState extends State<ApartmentDetailsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Get the Cubit and call the fetch method with the ID
//     context.read<ApartmentDetailsCubit>().fetchApartmentDetails(
//       widget.apartmentId,
//     );
//   }

//   Widget buildSliverAppBar(ApartmentModel apartmentModel) {
//     return SliverAppBar(
//       expandedHeight: 600,
//       pinned: true,
//       stretch: true,
//       // backgroundColor: AppColors.kBgMain,

//       // 1. CHANGE THIS COLOR: This is the background color of the bar when collapsed
//       backgroundColor: AppColors.kBgCard,

//       // 2. OPTIONAL: Add an iconTheme to ensure the back arrow is visible
//       iconTheme: const IconThemeData(color: AppColors.kFontColorDark),
//       flexibleSpace: FlexibleSpaceBar(
//         // centerTitle: true,
//         title: Text(
//           // textAlign: TextAlign.center,
//           '${apartmentModel.governorate}, ${apartmentModel.city}',
//           style: TextStyle(
//             color: AppColors.kFontColorDark,
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         background: Hero(
//           tag: apartmentModel.id.toString(),
//           child: Image.network(
//             apartmentModel.imageUrl.toString(),
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }

//   apartmentInfo(String title, String value) {
//     return RichText(
//       maxLines: 10,
//       overflow: TextOverflow.ellipsis,
//       text: TextSpan(
//         children: [
//           TextSpan(
//             text: title,
//             style: TextStyle(
//               color: AppColors.kFontColorDark,
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//           TextSpan(
//             text: value,
//             style: TextStyle(color: AppColors.kFontColorDark, fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildDivider(double endIndent) {
//     return Divider(
//       height: 30,
//       endIndent: endIndent,
//       color: AppColors.kFontColorLight,
//       thickness: 2,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kFontColorLight,
//       body: BlocBuilder<ApartmentDetailsCubit, ApartmentDetailsState>(
//         builder: (context, state) {
//           if (state is ApartmentDetailsLoading) {
//             return Center(
//               child: CircularProgressIndicator(color: AppColors.kFontColorDark),
//             );
//           }

//           if (state is ApartmentDetailsError) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Text(
//                   'Error loading details: ${state.message}',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: AppColors.kColorDanger, fontSize: 18),
//                 ),
//               ),
//             );
//           }

//           if (state is ApartmentDetailsLoaded) {
//             final apartmentModel = state.apartment;
//             return CustomScrollView(
//               slivers: [
//                 buildSliverAppBar(apartmentModel),
//                 SliverList(
//                   delegate: SliverChildListDelegate([
//                     Container(
//                       margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
//                       padding: EdgeInsets.all(8),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,

//                         children: [
//                           apartmentInfo(
//                             'Governorate : ',
//                             apartmentModel.governorate.toString(),
//                           ),
//                           buildDivider(150),

//                           apartmentInfo(
//                             'City : ',
//                             apartmentModel.city.toString(),
//                           ),
//                           buildDivider(200),
//                           apartmentInfo(
//                             'Price(SYP) : ',
//                             apartmentModel.price.toString(),
//                           ),
//                           buildDivider(100),
//                           apartmentInfo(
//                             'Area (sqm) : ',
//                             apartmentModel.area.toString(),
//                           ),
//                           buildDivider(80),

//                           apartmentInfo(
//                             'Rooms : ',
//                             apartmentModel.rooms.toString(),
//                           ),
//                           buildDivider(180),
//                           apartmentInfo(
//                             'floor : ',
//                             apartmentModel.floor.toString(),
//                           ),
//                           buildDivider(180),
//                           apartmentInfo(
//                             'Description : ',
//                             (apartmentModel.description ?? '').toString(),
//                           ),
//                           buildDivider(50),
//                           apartmentInfo(
//                             'rate : ',
//                             (apartmentModel.rate ?? '').toString(),
//                           ),
//                           buildDivider(120),
//                           SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 600),
//                   ]),
//                 ),
//               ],
//             );
//           }
//           return const SizedBox.shrink();
//         },
//       ),

//       // --- ADD THIS SECTION ---
//       bottomNavigationBar: BlocBuilder<ApartmentDetailsCubit, ApartmentDetailsState>(
//         builder: (context, state) {
//           if (state is ApartmentDetailsLoaded) {
//             return Container(
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: AppColors.kBgMain, // Or any background color
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 4,
//                     offset: Offset(0, -2),
//                   ),
//                 ],
//               ),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.kFontColorDark,
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () {
//                   // Navigate to Booking Details
//                   // Replace 'BookingDetailsScreen' with your actual class name
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           BookingDetailsScreen(apartment: state.apartment),
//                     ),
//                   );
//                 },
//                 child: const Text(
//                   "Book Now",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             );
//           }
//           return const SizedBox.shrink(); // Hide button while loading or error
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_ui/business_logic/apartment_details_cubit/cubit/apartment_details_cubit.dart';
import 'package:pluto_ui/constants/app_colors.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';
import 'package:pluto_ui/presentation/screens/booking_details_screen.dart';
import 'package:easy_localization/easy_localization.dart';


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
    context.read<ApartmentDetailsCubit>().fetchApartmentDetails(
      widget.apartmentId,
    );
  }

  Widget buildSliverAppBar(ApartmentModel apartmentModel, ThemeData theme) {
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;

    return SliverAppBar(
      expandedHeight: 450,
      pinned: true,
      stretch: true,
      backgroundColor: theme.cardColor,
      iconTheme: IconThemeData(color: fontColor),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          '${apartmentModel.governorate}, ${apartmentModel.city}',
          style: TextStyle(
            color: fontColor,
            fontSize: 25,
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

  Widget apartmentInfo(String title, String value, ThemeData theme) {
    final fontColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        maxLines: 10,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: TextStyle(
                color: fontColor,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: fontColor?.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDivider(double endIndent, ThemeData theme) {
    return Divider(
      height: 30,
      endIndent: endIndent,
      color: theme.dividerColor.withOpacity(0.2),
      thickness: 1.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<ApartmentDetailsCubit, ApartmentDetailsState>(
        builder: (context, state) {
          if (state is ApartmentDetailsLoading) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (state is ApartmentDetailsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Error loading details: ${state.message}'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.kColorDanger, fontSize: 18),
                ),
              ),
            );
          }

          if (state is ApartmentDetailsLoaded) {
            final apartmentModel = state.apartment;
            return CustomScrollView(
              slivers: [
                buildSliverAppBar(apartmentModel, theme),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      margin: const EdgeInsetsDirectional.all(16),
                      padding: const EdgeInsetsDirectional.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          apartmentInfo(
                            'Governorate : '.tr(),
                            apartmentModel.governorate.toString(),
                            theme,
                          ),
                          SizedBox(height: 20),

                          apartmentInfo(
                            'City : '.tr(),
                            apartmentModel.city.toString(),
                            theme,
                          ),
                          SizedBox(height: 20),

                          apartmentInfo(
                            'Price (SYP) : '.tr(),
                            apartmentModel.price.toString(),
                            theme,
                          ),
                          SizedBox(height: 20),

                          apartmentInfo(
                            'Area (sqm) : '.tr(),
                            apartmentModel.area.toString(),
                            theme,
                          ),
                          SizedBox(height: 20),

                          apartmentInfo(
                            'Rooms : '.tr(),
                            apartmentModel.rooms.toString(),
                            theme,
                          ),
                          SizedBox(height: 20),

                          apartmentInfo(
                            'Floor : '.tr(),
                            apartmentModel.floor.toString(),
                            theme,
                          ),

                          SizedBox(height: 20),
                          apartmentInfo(
                            'Description : '.tr(),
                            (apartmentModel.description ?? '').toString(),
                            theme,
                          ),
                          SizedBox(height: 20),

                          apartmentInfo(
                            'Rate : '.tr(),
                            (apartmentModel.rate ?? '0').toString(),
                            theme,
                          ),
                          const SizedBox(height: 250),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar:
          BlocBuilder<ApartmentDetailsCubit, ApartmentDetailsState>(
            builder: (context, state) {
              if (state is ApartmentDetailsLoaded) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingDetailsScreen(
                              apartment: state.apartment,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Book Now".tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
    );
  }
}

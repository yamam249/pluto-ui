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
      body: RefreshIndicator(
        color: theme.primaryColor,
        backgroundColor: theme.cardColor,
        onRefresh: () async {
          await context.read<ApartmentDetailsCubit>().fetchApartmentDetails(
            widget.apartmentId,
          );
        },
        child: BlocBuilder<ApartmentDetailsCubit, ApartmentDetailsState>(
          builder: (context, state) {
            if (state is ApartmentDetailsLoading) {
              return Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }

            if (state is ApartmentDetailsError) {
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

            if (state is ApartmentDetailsLoaded) {
              final apartmentModel = state.apartment;
              return CustomScrollView(
                slivers: [
                  buildSliverAppBar(apartmentModel, theme),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            apartmentInfo(
                              'Governorate : ',
                              apartmentModel.governorate.toString(),
                              theme,
                            ),
                            SizedBox(height: 20),

                            apartmentInfo(
                              'City : ',
                              apartmentModel.city.toString(),
                              theme,
                            ),
                            SizedBox(height: 20),

                            apartmentInfo(
                              'Price (SYP) : ',
                              apartmentModel.price.toString(),
                              theme,
                            ),
                            SizedBox(height: 20),

                            apartmentInfo(
                              'Area (sqm) : ',
                              apartmentModel.area.toString(),
                              theme,
                            ),
                            SizedBox(height: 20),

                            apartmentInfo(
                              'Rooms : ',
                              apartmentModel.rooms.toString(),
                              theme,
                            ),
                            SizedBox(height: 20),

                            apartmentInfo(
                              'Floor : ',
                              apartmentModel.floor.toString(),
                              theme,
                            ),

                            SizedBox(height: 20),
                            apartmentInfo(
                              'Description : ',
                              (apartmentModel.description ?? '').toString(),
                              theme,
                            ),
                            SizedBox(height: 20),

                            apartmentInfo(
                              'Rate : ',
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

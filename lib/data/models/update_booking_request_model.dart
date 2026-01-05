class UpdateBookingRequestModel {
  final String newFromDate;
  final String newToDate;

  UpdateBookingRequestModel({
    required this.newFromDate,
    required this.newToDate,
  });

  Map<String, dynamic> toJson() => {
    'new_from_date': newFromDate,
    'new_to_date': newToDate,
  };
}

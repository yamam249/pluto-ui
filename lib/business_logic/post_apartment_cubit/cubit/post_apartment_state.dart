part of 'post_apartment_cubit.dart';

sealed class PostApartmentState extends Equatable {
  const PostApartmentState();

  @override
  List<Object?> get props => [];
}

final class PostApartmentInitial extends PostApartmentState {}

final class PostApartmentLoading extends PostApartmentState {}

final class PostApartmentSuccess extends PostApartmentState {
  final String message;
  const PostApartmentSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class PostApartmentError extends PostApartmentState {
  final dynamic error;
  const PostApartmentError(this.error);

  @override
  List<Object?> get props => [error];
}

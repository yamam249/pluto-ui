part of 'rating_cubit.dart';

sealed class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object> get props => [];
}

final class RatingInitial extends RatingState {}

final class RatingLoading extends RatingState {}

final class RatingSuccess extends RatingState {
  final String message;
  const RatingSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class RatingError extends RatingState {
  final String message;
  const RatingError(this.message);

  @override
  List<Object> get props => [message];
}

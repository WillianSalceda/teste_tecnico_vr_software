part of 'create_listing_bloc.dart';

sealed class CreateListingState extends Equatable {
  const CreateListingState();

  @override
  List<Object?> get props => [];
}

class CreateListingFormState extends CreateListingState {
  const CreateListingFormState({
    this.type = 'sale',
    this.imagePath,
    this.isLoading = false,
    this.errorMessage,
    this.success = false,
  });

  final String type;
  final String? imagePath;
  final bool isLoading;
  final String? errorMessage;
  final bool success;

  static const _sentinel = Object();

  CreateListingFormState copyWith({
    String? type,
    Object? imagePath = _sentinel,
    bool? isLoading,
    Object? errorMessage = _sentinel,
    bool? success,
  }) => CreateListingFormState(
    type: type ?? this.type,
    imagePath: identical(imagePath, _sentinel)
        ? this.imagePath
        : imagePath as String?,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: identical(errorMessage, _sentinel)
        ? this.errorMessage
        : errorMessage as String?,
    success: success ?? this.success,
  );

  @override
  List<Object?> get props => [
    type,
    imagePath,
    isLoading,
    errorMessage,
    success,
  ];
}

class CreateListingNavigateState extends CreateListingState {
  const CreateListingNavigateState(this.route);

  final String route;

  @override
  List<Object?> get props => [route];
}

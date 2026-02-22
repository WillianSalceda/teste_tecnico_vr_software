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
    this.addressFilledFromCep = false,
  });

  final String type;
  final String? imagePath;
  final bool isLoading;
  final String? errorMessage;
  final bool success;
  final bool addressFilledFromCep;

  static const _sentinel = Object();

  CreateListingFormState copyWith({
    String? type,
    Object? imagePath = _sentinel,
    bool? isLoading,
    Object? errorMessage = _sentinel,
    bool? success,
    bool? addressFilledFromCep,
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
    addressFilledFromCep: addressFilledFromCep ?? this.addressFilledFromCep,
  );

  @override
  List<Object?> get props => [
    type,
    imagePath,
    isLoading,
    errorMessage,
    success,
    addressFilledFromCep,
  ];
}

class CreateListingNavigateState extends CreateListingState {
  const CreateListingNavigateState(this.route);

  final String route;

  @override
  List<Object?> get props => [route];
}

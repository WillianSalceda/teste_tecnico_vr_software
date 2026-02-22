part of 'create_listing_bloc.dart';

abstract class CreateListingEvent extends Equatable {
  const CreateListingEvent();

  @override
  List<Object?> get props => [];
}

class CepLookupSucceeded extends CreateListingEvent {
  const CepLookupSucceeded(this.address);

  final Address address;

  @override
  List<Object?> get props => [address];
}

class CreateListingTypeChanged extends CreateListingEvent {
  const CreateListingTypeChanged(this.type);

  final String type;

  @override
  List<Object?> get props => [type];
}

class CreateListingImagePathChanged extends CreateListingEvent {
  const CreateListingImagePathChanged(this.path);

  final String path;

  @override
  List<Object?> get props => [path];
}

class CreateListingSubmitted extends CreateListingEvent {
  const CreateListingSubmitted();
}

class NavigateTo extends CreateListingEvent {
  const NavigateTo(this.route);

  final String route;

  @override
  List<Object?> get props => [route];
}

class NavigationHandled extends CreateListingEvent {
  const NavigationHandled();
}

class AddressRevalidationHandled extends CreateListingEvent {
  const AddressRevalidationHandled();
}

part of 'listing_bloc.dart';

sealed class ListingState extends Equatable {
  const ListingState();

  @override
  List<Object?> get props => [];
}

class ListingInitial extends ListingState {
  const ListingInitial();
}

class ListingFilterUpdated extends ListingState {
  const ListingFilterUpdated({this.typeFilter});

  final String? typeFilter;

  @override
  List<Object?> get props => [typeFilter];
}

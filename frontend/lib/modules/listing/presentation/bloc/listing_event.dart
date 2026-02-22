part of 'listing_bloc.dart';

abstract class ListingEvent extends Equatable {
  const ListingEvent();

  @override
  List<Object?> get props => [];
}

class ListingFilterChanged extends ListingEvent {
  const ListingFilterChanged(this.type);

  final String? type;

  @override
  List<Object?> get props => [type];
}

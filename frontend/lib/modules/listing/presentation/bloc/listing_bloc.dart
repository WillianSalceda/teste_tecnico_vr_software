import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/listing.dart';
import '../../domain/usecases/get_listings.dart';

part 'listing_event.dart';
part 'listing_state.dart';

class ListingBloc extends Bloc<ListingEvent, ListingState> {
  ListingBloc(this._getListings) : super(const ListingInitial()) {
    on<ListingFilterChanged>(_onFilterChanged);
  }

  final GetListings _getListings;

  static const int pageSize = 10;

  Future<List<Listing>> fetchPage(int pageKey, String? typeFilter) async {
    final result = await _getListings(
      GetListingsParams(
        page: pageKey,
        limit: pageSize,
        type: typeFilter,
      ),
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data.listings,
    );
  }

  Future<void> _onFilterChanged(
    ListingFilterChanged event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingFilterUpdated(typeFilter: event.type));
  }
}

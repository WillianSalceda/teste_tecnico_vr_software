import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_l10n.dart';
import '../../../../core/refresh/listing_refresh_notifier.dart';
import '../../domain/entities/listing.dart';
import '../bloc/listing_bloc.dart';
import '../components/listing_card.dart';
import '../components/listing_filter_chip.dart';

class ListingPage extends StatelessWidget {
  const ListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = sl<Locale>();
    final l10n = AppL10n(locale: locale);

    return BlocProvider<ListingBloc>(
      create: (_) => sl<ListingBloc>(),
      child: _ListingContent(l10n: l10n),
    );
  }
}

class _ListingContent extends StatefulWidget {
  const _ListingContent({required this.l10n});

  final AppL10n l10n;

  @override
  State<_ListingContent> createState() => _ListingContentState();
}

class _ListingContentState extends State<_ListingContent> {
  late final ListingRefreshNotifier _refreshNotifier;
  late final PagingController<int, Listing> _pagingController;
  late final ListingBloc _bloc;

  String? _typeFilter;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ListingBloc>();
    _refreshNotifier = sl<ListingRefreshNotifier>();
    _refreshNotifier.addListener(_onRefresh);
    _pagingController = PagingController<int, Listing>(
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: (pageKey) => _bloc.fetchPage(pageKey, _typeFilter),
    );
  }

  @override
  void dispose() {
    _refreshNotifier.removeListener(_onRefresh);
    _pagingController.dispose();
    super.dispose();
  }

  void _onRefresh() {
    if (mounted) _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListingBloc, ListingState>(
      listenWhen: (_, curr) => curr is ListingFilterUpdated,
      listener: (context, state) {
        if (state is ListingFilterUpdated && mounted) {
          setState(() => _typeFilter = state.typeFilter);
          _pagingController.refresh();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.l10n.listings),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.go('/create-listing'),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ListingFilterChip(
                selectedType: _typeFilter,
                allLabel: widget.l10n.all,
                saleLabel: widget.l10n.sale,
                rentLabel: widget.l10n.rent,
                filterLabel: widget.l10n.filterByType,
                onTypeChanged: (t) {
                  context.read<ListingBloc>().add(ListingFilterChanged(t));
                },
              ),
            ),
            Expanded(
              child: PagingListener<int, Listing>(
                controller: _pagingController,
                builder: (context, state, fetchNextPage) =>
                    PagedListView<int, Listing>(
                      state: state,
                      fetchNextPage: fetchNextPage,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      builderDelegate: PagedChildBuilderDelegate<Listing>(
                        itemBuilder: (context, item, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ListingCard(
                            listing: item,
                            l10n: widget.l10n,
                          ),
                        ),
                        noItemsFoundIndicatorBuilder: (_) => Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(widget.l10n.noListings),
                              const SizedBox(height: 16),
                              FilledButton(
                                onPressed: () => context.go('/create-listing'),
                                child: Text(widget.l10n.createListing),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

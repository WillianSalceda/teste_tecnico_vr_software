import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_l10n.dart';
import '../../../../core/refresh/listing_refresh_notifier.dart';
import '../../../../core/theme/app_theme.dart';
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
        backgroundColor: AppTheme.light.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(widget.l10n.listings),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
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
                    PagedGridView<int, Listing>(
                      state: state,
                      fetchNextPage: fetchNextPage,
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: 3,
                          ),
                      builderDelegate: PagedChildBuilderDelegate<Listing>(
                        itemBuilder: (context, item, index) => ListingCard(
                          listing: item,
                          l10n: widget.l10n,
                        ),
                        noItemsFoundIndicatorBuilder: (_) => _EmptyState(
                          l10n: widget.l10n,
                          onAddTap: () => context.go('/create-listing'),
                        ),
                      ),
                    ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => context.go('/create-listing'),
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: Text(widget.l10n.createListing),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.l10n,
    required this.onAddTap,
  });

  final AppL10n l10n;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.home_work_outlined,
                size: 64,
                color: Color(0xFF0D9488),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noListings,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAddTap,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: Text(l10n.createListing),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

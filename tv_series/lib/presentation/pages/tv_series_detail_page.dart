import 'package:core/core.dart';
import 'package:core/presentation/widgets/button_watchlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

class TVSeriesDetailPage extends StatefulWidget {
  const TVSeriesDetailPage({super.key, required this.id});
  final int id;
  @override
  State<TVSeriesDetailPage> createState() => _TVSeriesDetailPageState();
}

class _TVSeriesDetailPageState extends State<TVSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TVSeriesDetailBloc>().add(FetchTVSeriesDetail(widget.id));
        context
            .read<TVSeriesDetailBloc>()
            .add(LoadWatchlistStatusTVSeries(widget.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<TVSeriesDetailBloc, TVSeriesDetailState>(
        builder: (context, state) {
          if (state.tvSeriesState == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.tvSeriesState == RequestState.Loaded) {
            final tvSeries = state.tvSeriesDetail!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://image.tmdb.org/t/p/w500/${tvSeries.posterPath}',
                          width: 200,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tvSeries.name,
                      style: kHeading5,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Visibility(
                      visible: tvSeries.genres.isNotEmpty,
                      child: Text(
                        tvSeries.genres.map((genre) => genre.name).join(', '),
                        style: kSubtitle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'First Air Date: ${tvSeries.firstAirDate}',
                      style: kSubtitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Episodes: ${tvSeries.numberOfEpisodes ?? 'N/A'}',
                      style: kSubtitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        Text('${tvSeries.voteAverage}', style: kSubtitle),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Overview', style: kHeading6),
                    ),
                    Text(tvSeries.overview, style: kBodyText),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Season', style: kHeading6),
                    ),
                    Container(
                      height: 150,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final season = tvSeries.seasons[index];
                          return _PosterWithClick(
                            imageUrl: season.posterPath,
                            onTap: () {
                              showModalBottomSheet(
                                showDragHandle: true,
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return SafeArea(
                                    bottom: true,
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl:
                                                  'https://image.tmdb.org/t/p/w500/${season.posterPath}',
                                              width: 100,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(season.name, style: kHeading6),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Air Date: ${season.airDate}',
                                              style: kSubtitle,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Episode Count: ${season.episodeCount}',
                                              style: kSubtitle,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Rating: ${season.voteAverage}',
                                              style: kSubtitle,
                                            ),
                                            const SizedBox(height: 16),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Overview',
                                                style: kHeading6,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                season.overview.isEmpty
                                                    ? 'No overview available.'
                                                    : season.overview,
                                                style: kBodyText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        itemCount: tvSeries.seasons.length,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Recommendations', style: kHeading6),
                    ),
                    BlocBuilder<TVSeriesDetailBloc, TVSeriesDetailState>(
                      builder: (context, state) {
                        if (state.recommendationState == RequestState.Loading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state.recommendationState ==
                            RequestState.Loaded) {
                          final recommendations = state.tvSeriesRecommendations;
                          return Container(
                            height: 150,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final recommendation = recommendations[index];
                                return _PosterWithClick(
                                  imageUrl: recommendation.posterPath,
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      TV_SERIES_DETAIL_ROUTE,
                                      arguments: recommendation.id,
                                    );
                                  },
                                );
                              },
                              itemCount: recommendations.length,
                            ),
                          );
                        } else {
                          return Text(state.message);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text(state.message));
          }
        },
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: SizedBox(
          height: 50,
          child: BlocConsumer<TVSeriesDetailBloc, TVSeriesDetailState>(
            listenWhen: (previous, current) =>
                previous.watchlistMessage != current.watchlistMessage &&
                current.watchlistMessage.isNotEmpty,
            listener: (context, state) {
              final message = state.watchlistMessage;
              if (message == 'Added to Watchlist' ||
                  message == 'Removed from Watchlist') {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(content: Text(message));
                  },
                );
              }
            },
            builder: (context, state) {
              final isAddedWatchlist = state.isAddedToWatchlist;
              return ButtonWatchlist(
                onPressed: () {
                  if (!isAddedWatchlist) {
                    context
                        .read<TVSeriesDetailBloc>()
                        .add(AddWatchlistTVSeries(state.tvSeriesDetail!));
                  } else {
                    context
                        .read<TVSeriesDetailBloc>()
                        .add(RemoveFromWatchlistTVSeries(state.tvSeriesDetail!));
                  }
                },
                isAddedWatchlist: isAddedWatchlist,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PosterWithClick extends StatelessWidget {
  const _PosterWithClick({required this.imageUrl, required this.onTap});

  final VoidCallback onTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/w500/$imageUrl',
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}

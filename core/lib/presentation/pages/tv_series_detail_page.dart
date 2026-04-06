import 'package:core/core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/widgets/button_watchlist.dart';
import 'package:flutter/material.dart';

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
        Provider.of<TVSeriesDetailNotifier>(context, listen: false)
          ..fetchTVSeriesDetail(widget.id)
          ..fetchTVSeriesRecommendations(widget.id)
          ..loadWatchlistStatus(widget.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<TVSeriesDetailNotifier>(
        builder: (context, notifier, child) {
          if (notifier.state == RequestState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (notifier.state == RequestState.Loaded) {
            final tvSeries = notifier.tvSeriesDetail;
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
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      tvSeries.name,
                      style: kHeading5,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Visibility(
                      visible: tvSeries.genres.isNotEmpty,
                      child: Text(
                        tvSeries.genres.map((genre) => genre.name).join(', '),
                        style: kSubtitle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'First Air Date: ${tvSeries.firstAirDate}',
                      style: kSubtitle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Episodes: ${tvSeries.numberOfEpisodes ?? 'N/A'}',
                      style: kSubtitle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        Text('${tvSeries.voteAverage}', style: kSubtitle),
                      ],
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Overview', style: kHeading6),
                    ),
                    Text(tvSeries.overview, style: kBodyText),
                    SizedBox(height: 16),
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
                                              placeholder: (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                            SizedBox(height: 8),
                                            Text(season.name, style: kHeading6),
                                            SizedBox(height: 8),
                                            Text(
                                              'Air Date: ${season.airDate}',
                                              style: kSubtitle,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Episode Count: ${season.episodeCount}',
                                              style: kSubtitle,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Rating: ${season.voteAverage}',
                                              style: kSubtitle,
                                            ),
                                            SizedBox(height: 16),
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
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Recommendations', style: kHeading6),
                    ),
                    Consumer<TVSeriesDetailNotifier>(
                      builder: (context, notifier, child) {
                        if (notifier.recommendationsState ==
                            RequestState.Loading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (notifier.recommendationsState ==
                            RequestState.Loaded) {
                          final recommendations = notifier.recommendations;
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
                          return Text(notifier.message);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text(notifier.message));
          }
        },
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: SizedBox(
          height: 50,
          child: Consumer<TVSeriesDetailNotifier>(
            builder: (context, notifier, child) {
              final isAddedWatchlist = notifier.isAddedToWatchlist;
              return ButtonWatchlist(
                onPressed: () async {
                  if (!isAddedWatchlist) {
                    await notifier.addWatchlist(notifier.tvSeriesDetail);
                  } else {
                    await notifier.removeFromWatchlist(notifier.tvSeriesDetail);
                  }
                  if (!context.mounted) return;
                  final message = notifier.watchlistMessage;
                  if (message ==
                          TVSeriesDetailNotifier.watchlistAddSuccessMessage ||
                      message ==
                          TVSeriesDetailNotifier
                              .watchlistRemoveSuccessMessage) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(message)));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(content: Text(message));
                      },
                    );
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
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}

import 'package:core/core.dart';

import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';

import '../widgets/tv_series_card_list.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<WatchlistNotifier>(context, listen: false)
          ..fetchWatchlistMovies()
          ..fetchWatchlistTVSeries();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistNotifier>(context, listen: false)
      ..fetchWatchlistMovies()
      ..fetchWatchlistTVSeries();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Movies'),
              Tab(text: 'TV Series'),
            ],
            dividerColor: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              Consumer<WatchlistNotifier>(
                builder: (context, data, child) {
                  if (data.watchlistState == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (data.watchlistState == RequestState.Loaded) {
                    if (data.watchlistMovies.isEmpty) {
                      return Center(child: Text('Your watchlist is empty'));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      itemBuilder: (context, index) {
                        final movie = data.watchlistMovies[index];
                        return MovieCard(movie);
                      },
                      itemCount: data.watchlistMovies.length,
                    );
                  } else {
                    return Center(
                      key: Key('error_message'),
                      child: Text(data.message),
                    );
                  }
                },
              ),
              Consumer<WatchlistNotifier>(
                builder: (context, data, child) {
                  if (data.watchlistTVSeriesState == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (data.watchlistTVSeriesState ==
                      RequestState.Loaded) {
                    if (data.watchlistTVSeries.isEmpty) {
                      return Center(child: Text('Your watchlist is empty'));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      itemBuilder: (context, index) {
                        final tvSeries = data.watchlistTVSeries[index];
                        return TVSeriesCard(tvSeries);
                      },
                      itemCount: data.watchlistTVSeries.length,
                    );
                  } else {
                    return Center(
                      key: Key('error_message'),
                      child: Text(data.messageTVSeries),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

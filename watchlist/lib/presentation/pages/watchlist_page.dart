import 'package:core/core.dart';

import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/watchlist_movie_bloc.dart';
import '../bloc/watchlist_movie_event.dart';
import '../bloc/watchlist_movie_state.dart';
import '../bloc/watchlist_tv_series_bloc.dart';
import '../bloc/watchlist_tv_series_event.dart';
import '../bloc/watchlist_tv_series_state.dart';

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
        context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies());
        context.read<WatchlistTVSeriesBloc>().add(FetchWatchlistTVSeries());
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
    context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies());
    context.read<WatchlistTVSeriesBloc>().add(FetchWatchlistTVSeries());
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
              BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
                builder: (context, state) {
                  if (state is WatchlistMovieLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is WatchlistMovieHasData) {
                    if (state.result.isEmpty) {
                      return Center(child: Text('Your watchlist is empty'));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      itemBuilder: (context, index) {
                        final movie = state.result[index];
                        return MovieCard(movie);
                      },
                      itemCount: state.result.length,
                    );
                  } else if (state is WatchlistMovieError) {
                    return Center(
                      key: Key('error_message'),
                      child: Text(state.message),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              BlocBuilder<WatchlistTVSeriesBloc, WatchlistTVSeriesState>(
                builder: (context, state) {
                  if (state is WatchlistTVSeriesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is WatchlistTVSeriesHasData) {
                    if (state.result.isEmpty) {
                      return Center(child: Text('Your watchlist is empty'));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      itemBuilder: (context, index) {
                        final tvSeries = state.result[index];
                        return TVSeriesCard(tvSeries);
                      },
                      itemCount: state.result.length,
                    );
                  } else if (state is WatchlistTVSeriesError) {
                    return Center(
                      key: Key('error_message'),
                      child: Text(state.message),
                    );
                  } else {
                    return Container();
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

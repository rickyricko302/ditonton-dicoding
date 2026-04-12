import 'package:core/core.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';

import '../../search.dart';

class SearchPage extends StatelessWidget {
  final SearchType searchType;

  const SearchPage({super.key, required this.searchType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                if (query.isNotEmpty) {
                  FirebaseAnalyticsHelper.logEvent(
                    name: 'search',
                    parameters: {
                      'search_term': query,
                      'search_type': searchType.toString(),
                    },
                  );
                }
                if (searchType == SearchType.movie) {
                  context.read<SearchBloc>().add(
                    OnQueryMovieChanged(query: query),
                  );
                } else {
                  context.read<SearchBloc>().add(
                    OnQueryTVSeriesChanged(query: query),
                  );
                }
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            Builder(
              builder: (context) {
                if (searchType == SearchType.movie) {
                  return _SearchMovie();
                } else {
                  return _SearchTVSeries();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchMovie extends StatelessWidget {
  const _SearchMovie();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SearchHasData) {
          final result = state.movie;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final movie = state.movie[index];
                return MovieCard(movie);
              },
              itemCount: result.length,
            ),
          );
        } else if (state is SearchError) {
          return Expanded(child: Center(child: Text(state.message)));
        } else {
          return Expanded(child: Container());
        }
      },
    );

    // Ini versi menggunakan Provider, tapi sudah diganti ke BlocBuilder di atas
    // return Consumer<MovieSearchNotifier>(
    //   builder: (context, data, child) {
    //     if (data.state == RequestState.Loading) {
    //       return Center(child: CircularProgressIndicator());
    //     } else if (data.state == RequestState.Loaded) {
    //       final result = data.searchResult;
    //       return Expanded(
    //         child: ListView.builder(
    //           padding: const EdgeInsets.all(8),
    //           itemBuilder: (context, index) {
    //             final movie = data.searchResult[index];
    //             return MovieCard(movie);
    //           },
    //           itemCount: result.length,
    //         ),
    //       );
    //     } else {
    //       return Expanded(child: Container());
    //     }
    //   },
    // );
  }
}

class _SearchTVSeries extends StatelessWidget {
  const _SearchTVSeries();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SearchHasData) {
          final result = state.tvSeries;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final tvSeries = state.tvSeries[index];
                return TVSeriesCard(tvSeries);
              },
              itemCount: result.length,
            ),
          );
        } else if (state is SearchError) {
          return Expanded(child: Center(child: Text(state.message)));
        } else {
          return Expanded(child: Container());
        }
      },
    );

    // Ini versi menggunakan Provider, tapi sudah diganti ke BlocBuilder di bawah
    // return Consumer<TVSeriesSearchNotifier>(
    //   builder: (context, data, child) {
    //     if (data.state == RequestState.Loading) {
    //       return Center(child: CircularProgressIndicator());
    //     } else if (data.state == RequestState.Loaded) {
    //       final result = data.searchResult;
    //       return Expanded(
    //         child: ListView.builder(
    //           padding: const EdgeInsets.all(8),
    //           itemBuilder: (context, index) {
    //             final tvSeries = data.searchResult[index];
    //             return TVSeriesCard(tvSeries);
    //           },
    //           itemCount: result.length,
    //         ),
    //       );
    //     } else {
    //       return Expanded(child: Container());
    //     }
    //   },
    // );
  }
}

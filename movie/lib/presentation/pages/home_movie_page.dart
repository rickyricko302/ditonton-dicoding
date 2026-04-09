import 'package:core/core.dart';

import 'package:core/presentation/widgets/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import '../bloc/now_playing_movies_event.dart';
import '../bloc/now_playing_movies_state.dart';
import '../bloc/popular_movies_event.dart';
import '../bloc/popular_movies_state.dart';
import '../bloc/top_rated_movies_event.dart';
import '../bloc/top_rated_movies_state.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({super.key});

  @override
  State<HomeMoviePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<NowPlayingMoviesBloc>().add(FetchNowPlayingMovies());
        context.read<PopularMoviesBloc>().add(FetchPopularMovies());
        context.read<TopRatedMoviesBloc>().add(FetchTopRatedMovies());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
              decoration: BoxDecoration(color: Colors.grey.shade900),
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WATCHLIST_ROUTE);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ABOUT_ROUTE);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, TV_SERIES_ROUTE);
            },
            icon: Text(
              'TV Series',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                SEARCH_ROUTE,
                arguments: SearchType.movie,
              );
            },
            icon: Icon(Icons.search),
            tooltip: 'Search Movies',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Now Playing', style: kHeading6),
              BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
                builder: (context, state) {
                  if (state is NowPlayingMoviesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is NowPlayingMoviesHasData) {
                    return MovieList(state.result);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              SubHeading(
                title: 'Popular',
                onTap: () => Navigator.pushNamed(context, POPULAR_MOVIES_ROUTE),
              ),
              BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
                builder: (context, state) {
                  if (state is PopularMoviesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PopularMoviesHasData) {
                    return MovieList(state.result);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              SubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TOP_RATED_MOVIES_ROUTE),
              ),
              BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
                builder: (context, state) {
                  if (state is TopRatedMoviesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is TopRatedMoviesHasData) {
                    return MovieList(state.result);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MOVIE_DETAIL_ROUTE,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}

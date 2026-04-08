import 'package:about/about.dart';
import 'package:core/core.dart';

import 'package:flutter/material.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:movie/movie.dart';
import 'package:search/search.dart';
import 'package:tv_series/tv_series.dart';
import 'package:watchlist/presentation/pages/watchlist_page.dart';
import 'package:watchlist/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist_tv_series_bloc.dart';


void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.locator<MovieListNotifier>()),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        BlocProvider(create: (_) => di.locator<WatchlistMovieBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTVSeriesBloc>()),
        ChangeNotifierProvider(
          create: (_) => di.locator<TVSeriesListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularTVSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedTVSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TVSeriesDetailNotifier>(),
        ),
        BlocProvider(
          create: (context) => di.locator<SearchBloc>(),
          child: Container(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HOME_ROUTE:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case POPULAR_MOVIES_ROUTE:
              return MaterialPageRoute(builder: (_) => PopularMoviesPage());
            case TOP_RATED_MOVIES_ROUTE:
              return MaterialPageRoute(builder: (_) => TopRatedMoviesPage());
            case MOVIE_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SEARCH_ROUTE:
              final type = settings.arguments as SearchType;
              return MaterialPageRoute(
                builder: (_) => SearchPage(searchType: type),
                settings: settings,
              );
            case WATCHLIST_ROUTE:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            case ABOUT_ROUTE:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case TV_SERIES_ROUTE:
              return MaterialPageRoute(builder: (_) => TVSeriesPage());
            case POPULAR_TV_SERIES_ROUTE:
              return MaterialPageRoute(builder: (_) => PopularTVSeriesPage());
            case TOP_RATED_TV_SERIES_ROUTE:
              return MaterialPageRoute(builder: (_) => TopRatedTVSeriesPage());
            case TV_SERIES_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TVSeriesDetailPage(id: id),
                settings: settings,
              );
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return Scaffold(
                    body: Center(child: Text('Page not found :(')),
                  );
                },
              );
          }
        },
      ),
    );
  }
}

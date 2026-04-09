import 'package:core/core.dart';
import 'package:core/core.dart' as http;
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';

import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv_series_local_data_source.dart';
import 'package:core/data/datasources/tv_series_remote_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/data/repositories/tv_series_repository_impl.dart';
import 'package:core/data/services/watchlist_service.dart';
import 'package:core/domain/repositories/movie_repository.dart';

import 'package:get_it/get_it.dart';
import 'package:search/search.dart';
import 'package:watchlist/data/services/watchlist_service_impl.dart';
import 'package:watchlist/domain/usecases/get_watchlist_movies.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:watchlist/domain/usecases/get_watchlist_tv_series.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:watchlist/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:watchlist/domain/usecases/save_watchlist.dart';
import 'package:watchlist/domain/usecases/save_watchlist_tv_series.dart';
import 'package:watchlist/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist_tv_series_bloc.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(() => NowPlayingMoviesBloc(locator()));
  locator.registerFactory(() => PopularMoviesBloc(locator()));
  locator.registerFactory(() => TopRatedMoviesBloc(locator()));
  locator.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      watchlistService: locator(),
    ),
  );
  locator.registerFactory(() => WatchlistMovieBloc(locator()));
  locator.registerFactory(() => WatchlistTVSeriesBloc(locator()));
  locator.registerFactory(
    () => TVSeriesListNotifier(
      getTVSeriesAiringToday: locator(),
      getPopularTVSeries: locator(),
      getTopRatedTVSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTVSeriesNotifier(getPopularTVSeries: locator()),
  );
  locator.registerFactory(
    () => TopRatedTVSeriesNotifier(getTopRatedTVSeries: locator()),
  );
  locator.registerFactory(
    () => TVSeriesDetailNotifier(
      getTVSeriesDetail: locator(),
      getRecommendationsTVSeries: locator(),
      watchlistService: locator(),
    ),
  );

  locator.registerFactory(() => SearchBloc(locator(), locator()));

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetAiringTodayTVSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTVSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTVSeries(locator()));
  locator.registerLazySingleton(() => GetTVSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetRecommendationsTVSeries(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTVSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistStatusTVSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTVSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistTVSeries(locator()));
  locator.registerLazySingleton(() => SearchTVSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  locator.registerLazySingleton<TVSeriesRepository>(
    () => TVSeriesRepositoryImpl(
      localDataSource: locator(),
      remoteDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );
  locator.registerLazySingleton<TVSeriesRemoteDataSource>(
    () => TVSeriesRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<TVSeriesLocalDataSource>(
    () => TVSeriesLocalDataSourceImpl(databaseHelper: locator()),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // netwowrk info
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  // external
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => Connectivity());

  // services
  locator.registerLazySingleton<WatchlistService>(
    () => WatchlistServiceImpl(
      getWatchlistStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
      saveWatchlistTVSeries: locator(),
      getWatchlistStatusTVSeries: locator(),
      removeWatchlistTVSeries: locator(),
    ),
  );
}

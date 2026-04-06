import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/search.dart';
import 'package:bloc_test/bloc_test.dart';
import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies, SearchTVSeries])
void main() {
  late SearchBloc searchBloc;
  late MockSearchMovies mockSearchMovies;
  late MockSearchTVSeries mockSearchTVSeries;
  setUp(() {
    mockSearchMovies = MockSearchMovies();
    mockSearchTVSeries = MockSearchTVSeries();
    searchBloc = SearchBloc(mockSearchMovies, mockSearchTVSeries);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: '/backdrop.jpg',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/poster.jpg',
    releaseDate: '2023-01-01',
    title: 'spiderman',
    video: false,
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tMovieList = <Movie>[tMovie];

  final tQuery = 'spiderman';

  test('initial state should be empty', () {
    // assert
    expect(searchBloc.state, SearchEmpty());
  });

  blocTest<SearchBloc, SearchState>(
    'emits [Loading, HasData] when OnQueryChanged is added.',
    build: () {
      when(
        mockSearchMovies.execute(tQuery),
      ).thenAnswer((_) async => Right(tMovieList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryMovieChanged(query: tQuery)),
    wait: const Duration(milliseconds: 100),
    expect: () => <SearchState>[
      SearchLoading(),
      SearchHasData(movie: tMovieList, tvSeries: []),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );

  blocTest<SearchBloc, SearchState>(
    'emits [SearchError] when OnQueryChanged is added with an error.',
    build: () {
      when(
        mockSearchMovies.execute(tQuery),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryMovieChanged(query: tQuery)),
    expect: () => <SearchState>[
      SearchLoading(),
      SearchError(message: 'Server Failure'),
    ],
  );
}

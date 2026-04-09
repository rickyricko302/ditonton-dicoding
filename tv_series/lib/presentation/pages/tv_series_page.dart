import 'package:core/core.dart';
import 'package:core/presentation/widgets/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

class TVSeriesPage extends StatefulWidget {
  const TVSeriesPage({super.key});

  @override
  State<TVSeriesPage> createState() => _TVSeriesPageState();
}

class _TVSeriesPageState extends State<TVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<AiringTodayTVSeriesBloc>().add(FetchAiringTodayTVSeries());
        context.read<PopularTVSeriesBloc>().add(FetchPopularTVSeries());
        context.read<TopRatedTVSeriesBloc>().add(FetchTopRatedTVSeries());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                SEARCH_ROUTE,
                arguments: SearchType.tv,
              );
            },
            icon: const Icon(Icons.search),
            tooltip: 'Search TV Series',
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
              BlocBuilder<AiringTodayTVSeriesBloc, AiringTodayTVSeriesState>(
                builder: (context, state) {
                  if (state is AiringTodayTVSeriesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AiringTodayTVSeriesHasData) {
                    return TVSeriesList(
                      state.result,
                      keyPrefix: 'airing_today',
                    );
                  } else if (state is AiringTodayTVSeriesError) {
                    return Text(state.message);
                  } else {
                    return Container();
                  }
                },
              ),
              SubHeading(
                title: 'Popular',
                onTap: () {
                  Navigator.pushNamed(context, POPULAR_TV_SERIES_ROUTE);
                },
              ),
              BlocBuilder<PopularTVSeriesBloc, PopularTVSeriesState>(
                builder: (context, state) {
                  if (state is PopularTVSeriesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PopularTVSeriesHasData) {
                    return TVSeriesList(
                      state.result,
                      keyPrefix: 'popular',
                    );
                  } else if (state is PopularTVSeriesError) {
                    return Text(state.message);
                  } else {
                    return Container();
                  }
                },
              ),
              SubHeading(
                title: 'Top Rated',
                onTap: () {
                  Navigator.pushNamed(context, TOP_RATED_TV_SERIES_ROUTE);
                },
              ),
              BlocBuilder<TopRatedTVSeriesBloc, TopRatedTVSeriesState>(
                builder: (context, state) {
                  if (state is TopRatedTVSeriesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TopRatedTVSeriesHasData) {
                    return TVSeriesList(
                      state.result,
                      keyPrefix: 'top_rated',
                    );
                  } else if (state is TopRatedTVSeriesError) {
                    return Text(state.message);
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
}

class TVSeriesList extends StatelessWidget {
  final List<TVSeries> tvSeries;
  final String keyPrefix;
  const TVSeriesList(this.tvSeries, {super.key, required this.keyPrefix});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              key: Key("${keyPrefix}_$index"),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TV_SERIES_DETAIL_ROUTE,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}

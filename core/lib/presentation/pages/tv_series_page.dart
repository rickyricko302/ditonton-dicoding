import 'package:core/core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/presentation/widgets/sub_heading.dart';
import 'package:flutter/material.dart';

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
        Provider.of<TVSeriesListNotifier>(context, listen: false)
          ..fetchAiringTodayTVSeries()
          ..fetchPopularTVSeries()
          ..fetchTopRatedTVSeries();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                SEARCH_ROUTE,
                arguments: SearchType.tv,
              );
            },
            icon: Icon(Icons.search),
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
              Consumer<TVSeriesListNotifier>(
                builder: (context, data, child) {
                  final state = data.airingTodayState;
                  if (state == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.Loaded) {
                    return TVSeriesList(
                      data.airingTodayTVSeries,
                      keyPrefix: 'airing_today',
                    );
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              SubHeading(
                title: 'Popular',
                onTap: () {
                  Navigator.pushNamed(context, POPULAR_TV_SERIES_ROUTE);
                },
              ),
              Consumer<TVSeriesListNotifier>(
                builder: (context, data, child) {
                  final state = data.popularState;
                  if (state == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.Loaded) {
                    return TVSeriesList(
                      data.popularTVSeries,
                      keyPrefix: 'popular',
                    );
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              SubHeading(
                title: 'Top Rated',
                onTap: () {
                  Navigator.pushNamed(context, TOP_RATED_TV_SERIES_ROUTE);
                },
              ),
              Consumer<TVSeriesListNotifier>(
                builder: (context, data, child) {
                  final state = data.topRatedState;
                  if (state == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.Loaded) {
                    return TVSeriesList(
                      data.topRatedTVSeries,
                      keyPrefix: 'top_rated',
                    );
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
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
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

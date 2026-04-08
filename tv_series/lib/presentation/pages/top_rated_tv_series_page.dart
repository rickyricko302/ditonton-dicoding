import 'package:core/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:tv_series/tv_series.dart';

class TopRatedTVSeriesPage extends StatefulWidget {
  const TopRatedTVSeriesPage({super.key});

  @override
  State<TopRatedTVSeriesPage> createState() => _TopRatedTVSeriesPageState();
}

class _TopRatedTVSeriesPageState extends State<TopRatedTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<TopRatedTVSeriesNotifier>(
          context,
          listen: false,
        ).fetchTopRatedTVSeries();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedTVSeriesNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = data.topRatedTVSeries[index];
                  return TVSeriesCard(tvSeries);
                },
                itemCount: data.topRatedTVSeries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}

import 'package:core/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

class PopularTVSeriesPage extends StatefulWidget {
  const PopularTVSeriesPage({super.key});

  @override
  State<PopularTVSeriesPage> createState() => _PopularTVSeriesPageState();
}

class _PopularTVSeriesPageState extends State<PopularTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<PopularTVSeriesBloc>().add(FetchPopularTVSeries());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTVSeriesBloc, PopularTVSeriesState>(
          builder: (context, state) {
            if (state is PopularTVSeriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PopularTVSeriesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.result[index];
                  return TVSeriesCard(tvSeries);
                },
                itemCount: state.result.length,
              );
            } else if (state is PopularTVSeriesError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

import 'package:anysongs/core/extensions/context_exts.dart';
import 'package:anysongs/core/widgets/custom_stream.dart';
import 'package:anysongs/features/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen>
    with AutomaticKeepAliveClientMixin {
  late final homeBloc = context.read<HomeBloc>();
  late final thumbSize = context.percentWidthOf(0.2);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MyStreamWidget(
      stream: homeBloc.favoriteSongs.combineLatest(
        homeBloc.currentSong,
        (list, song) => (list, song),
      ),
      child: (pair) {
        final favList = pair.$1;
        final currentSong = pair.$2;
        return ListView.builder(
          itemCount: favList.length,
          itemBuilder: (context, index) {
            final song = favList[index];
            return const Placeholder();
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anysongs/core/widgets/loading.dart';
import 'package:anysongs/features/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen>
    with AutomaticKeepAliveClientMixin {
  late final homeBloc = context.read<HomeBloc>();
  @override
  void initState() {
    // homeBloc.getAllAlbum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) => current is HomeAlbumState,
      builder: (context, state) {
        return switch (state) {
          HomeFetchingAlbum _ => const Loading(),
          HomeAlbum albums => GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
              ),
              itemCount: albums.albums.length,
              itemBuilder: (context, index) {
                final album = albums.albums[index];
                return AlbumTile(album: album);
              },
            ),
          _ => const Placeholder(),
        };
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AlbumTile extends StatelessWidget {
  final AlbumModel album;
  const AlbumTile({
    Key? key,
    required this.album,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: QueryArtworkWidget(
              id: album.id,
              type: ArtworkType.ALBUM,
              artworkWidth: double.maxFinite,
            ),
          ),
          Text(
            album.album,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anysongs/core/extensions/context_exts.dart';
import 'package:anysongs/core/locale/locale.dart';
import 'package:anysongs/core/widgets/loading.dart';
import 'package:anysongs/features/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen>
    with AutomaticKeepAliveClientMixin {
  late final homeBloc = context.read<HomeBloc>();
  @override
  void initState() {
    // homeBloc.getAllPlaylist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) => current is HomePlayListState,
      builder: (context, state) {
        return switch (state) {
          HomeFetchingPlaylist _ => const Loading(),
          HomePlaylists playlists => playlists.playlists.isNotEmpty
              ? _buildPlayListGridView(playlists.playlists)
              : _buildEmpty(),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }

  Widget _buildPlayListGridView(List<PlaylistModel> playlists) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Row(
              children: [
                Text(Mylocale.createNewPlayList),
                const Spacer(),
                IconButton.filledTonal(
                  onPressed: onCreatePlaylistClick,
                  icon: const Icon(
                    Icons.playlist_add_rounded,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200),
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return _PlaylistTile(
                  model: playlist,
                  onTap: () {
                    context.navigateToScreen(
                      MyPlaylistViewScreen(playlistModel: playlist),
                    );
                  },
                  onLongTap: () {
                    deletePlaylist(playlist);
                  },
                );
              },
            ),
          )
        ],
      );

  Widget _buildEmpty() => Center(
        child: FilledButton.tonalIcon(
          onPressed: onCreatePlaylistClick,
          icon: const Icon(Icons.playlist_add),
          label: Text(Mylocale.createNewPlayList),
        ),
      );

  void deletePlaylist(PlaylistModel playlist) {
    context.showBlurDialog(title: Mylocale.delete, childs: [
      Text(
        '${Mylocale.sureDelete} \'${playlist.playlist}\'',
        style: context.textTheme.bodyMedium,
      ),
      TextButton(
          onPressed: () {
            // homeBloc.deletePlayList(playlist.id).then((deleted) {
            //   if (!deleted) {
            //     context.showSnackBar(SnackBar(content: Text(Mylocale.sww)));
            //     return;
            //   }
            //   homeBloc.getAllPlaylist();
            //   Navigator.pop(context);
            // });
          },
          child: Text(
            Mylocale.delete,
            style: const TextStyle(
              color: Colors.red,
            ),
          ))
    ]);
  }

  void onCreatePlaylistClick() {
    final TextEditingController textEditingController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(Mylocale.createNew),
        content: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            label: Text(
              Mylocale.enterPlaylistName,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final name = textEditingController.text.trim();
              if (name.isEmpty) return;
              homeBloc.localSongsRepo
                  .createNewPlayList(textEditingController.text.trim())
                  .then((created) {
                if (!created) {
                  context.showSnackBar(
                    SnackBar(
                      content: Text(Mylocale.sww),
                    ),
                  );
                }
                Navigator.pop(context);
                // homeBloc.getAllPlaylist();
              });
            },
            child: Text(
              Mylocale.ok,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _PlaylistTile extends StatelessWidget {
  final PlaylistModel model;
  final VoidCallback onTap;
  final VoidCallback onLongTap;
  const _PlaylistTile({
    Key? key,
    required this.model,
    required this.onTap,
    required this.onLongTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongTap,
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: QueryArtworkWidget(
                id: model.id,
                type: ArtworkType.PLAYLIST,
                artworkWidth: double.maxFinite,
              ),
            ),
            Text(
              model.playlist,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class MyPlaylistViewScreen extends StatelessWidget {
  final PlaylistModel playlistModel;
  const MyPlaylistViewScreen({
    Key? key,
    required this.playlistModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(playlistModel.playlist),
              background: QueryArtworkWidget(
                id: playlistModel.id,
                type: ArtworkType.PLAYLIST,
              ),
            ),
          ),
          SliverList.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text(
                index.toString(),
              ),
            ),
            itemCount: 100,
          ),
        ],
      ),
    );
  }
}

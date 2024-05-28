// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anysongs/core/extensions/context_exts.dart';
import 'package:anysongs/core/locale/locale.dart';
import 'package:anysongs/core/models/state.dart';
import 'package:anysongs/core/utils/debug.dart';
import 'package:anysongs/core/widgets/error.dart';
import 'package:anysongs/core/widgets/loading.dart';
import 'package:anysongs/core/widgets/my_artwork_widget.dart';
import 'package:anysongs/features/home/playlist/models/playlist_data.dart';
import 'package:anysongs/features/home/playlist/screens/playlist_songs_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../cubit/playlist_cubit.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen>
    with AutomaticKeepAliveClientMixin {
  late final playlistCubit = context.read<PlaylistCubit>();
  @override
  void initState() {
    super.initState();
    playlistCubit.getAllPlaylist();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return BlocBuilder<PlaylistCubit, MyState<PlaylistData>>(
      builder: (context, state) {
        return switch (state) {
          LoadingState _ => const Loading(),
          SuccessState<PlaylistData> success =>
            _Playlist(list: success.data.playlistItems),
          ErrorState<PlaylistData> failure => MyError(
              error: failure.error,
            ),
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
                return null;
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
              // final name = textEditingController.text.trim();
              // if (name.isEmpty) return;
              // homeBloc.localSongsRepo
              //     .createNewPlayList(textEditingController.text.trim())
              //     .then((created) {
              //   if (!created) {
              //     context.showSnackBar(
              //       SnackBar(
              //         content: Text(Mylocale.sww),
              //       ),
              //     );
              //   }
              //   Navigator.pop(context);
              //   // homeBloc.getAllPlaylist();
              // });
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
  bool get wantKeepAlive => false;
}

class CreateNewPlaylistWidget extends StatelessWidget {
  final VoidCallback onCreatePlaylistClick;
  const CreateNewPlaylistWidget({
    Key? key,
    required this.onCreatePlaylistClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
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
    );
  }
}

class _Playlist extends StatefulWidget {
  final List<PlaylistItem> list;

  const _Playlist({super.key, required this.list});

  @override
  State<_Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<_Playlist> {
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
              final playlistCubit = context.read<PlaylistCubit>();
              playlistCubit.createNewPlayList(name).then((id) {
                mp(id);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaylistSongsAddScreen(
                        playlistId: id,
                      ),
                    )).then((_) {
                  playlistCubit.getAllPlaylist();
                });
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
  Widget build(BuildContext context) {
    return widget.list.isEmpty
        ? Center(
            child: FilledButton.tonalIcon(
              onPressed: onCreatePlaylistClick,
              icon: const Icon(Icons.playlist_add),
              label: Text(Mylocale.createNewPlayList),
            ),
          )
        : Column(
            children: [
              CreateNewPlaylistWidget(
                onCreatePlaylistClick: onCreatePlaylistClick,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.list.length,
                  itemBuilder: (context, index) {
                    final playlist = widget.list[index];
                    return ListTile(
                      leading: SizedBox(
                        width: context.percentWidthOf(0.2),
                        height: context.percentWidthOf(0.2),
                        child: MyArtWorkWidget2(
                          uri: playlist.firstThumbUri == null ||
                                  playlist.firstThumbUri!.isEmpty
                              ? null
                              : Uri.parse(playlist.firstThumbUri!),
                          width: double.maxFinite,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      title: Text(playlist.playlistName),
                      subtitle: Text(playlist.count.toString()),
                      onLongPress: () {
                        final cubit = context.read<PlaylistCubit>();

                        cubit
                            .deletePlayList(playlist.playlistId)
                            .then((_) => cubit.getAllPlaylist());
                      },
                    );
                  },
                ),
              ),
            ],
          );
  }
}

class _PlaylistTile extends StatelessWidget {
  final PlaylistItem model;
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
              child: MyArtWorkWidget2(
                uri: model.firstThumbUri == null || model.firstThumbUri!.isEmpty
                    ? null
                    : Uri.parse(model.firstThumbUri!),
                width: double.maxFinite,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    model.playlistName,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  decoration: BoxDecoration(
                    border: Border.all(color: context.colorScheme.primary),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    model.count.toString(),
                    style: TextStyle(color: context.colorScheme.primary),
                  ),
                ),
              ],
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

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anysongs/core/locale/locale.dart';
import 'package:flutter/material.dart';

class ShuffleTile extends StatelessWidget {
  final VoidCallback onShuffleClick;
  const ShuffleTile({
    Key? key,
    required this.onShuffleClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onShuffleClick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton.filledTonal(
                onPressed: onShuffleClick,
                icon: const Icon(Icons.shuffle_rounded)),
            const SizedBox(height: 16),
            Text(Mylocale.shufflePlayback),
          ],
        ),
      ),
    );
  }
}

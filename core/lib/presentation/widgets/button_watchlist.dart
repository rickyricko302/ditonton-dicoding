import 'package:flutter/material.dart';

class ButtonWatchlist extends StatelessWidget {
  const ButtonWatchlist({
    super.key,
    required this.onPressed,
    required this.isAddedWatchlist,
  });
  final VoidCallback onPressed;
  final bool isAddedWatchlist;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isAddedWatchlist ? Icon(Icons.check) : Icon(Icons.add),
          Text('Watchlist'),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hit_confirm/models/enums.dart';

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({
    super.key,
    required this.gameState,
    required this.reactionFrames,
    required this.colorChangeFrames,
    required this.onChangeReactionFrames,
    required this.onChangeColorChangeFrames,
  });

  final GameState gameState;
  final double reactionFrames;
  final double colorChangeFrames;
  final ValueChanged<double> onChangeReactionFrames;
  final ValueChanged<double> onChangeColorChangeFrames;

  bool get _slidersEnabled => gameState == GameState.waiting;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '反応時間: ${reactionFrames.round()}F '
              '(${(reactionFrames * 16.67 / 1000).toStringAsFixed(2)}s)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Slider(
              value: reactionFrames,
              min: 10.0,
              max: 60.0,
              divisions: 50,
              onChanged: _slidersEnabled ? onChangeReactionFrames : null,
            ),
            Text(
              '色変化: ${colorChangeFrames.round()}F '
              '(${(colorChangeFrames * 16.67 / 1000).toStringAsFixed(2)}s)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Slider(
              value: colorChangeFrames,
              min: 1.0,
              max: 60.0,
              divisions: 59,
              onChanged: _slidersEnabled ? onChangeColorChangeFrames : null,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hit_confirm/models/enums.dart';

/// メインのアクションボタン（スタート/追撃）
/// - 見た目と有効/無効状態の制御だけ担当
class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.gameState,
    this.onTapDown,
  });

  final GameState gameState;
  final ValueChanged<TapDownDetails>? onTapDown;

  Color _buttonColor() {
    if (gameState == GameState.waiting) return Colors.green;
    if (gameState == GameState.active) return Colors.red;
    return Colors.grey;
  }

  String _label() => gameState == GameState.waiting ? 'スタート' : '追撃';

  bool get _isTapEnabled =>
      gameState == GameState.waiting || gameState == GameState.active;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 60,
      child: Material(
        color: _buttonColor(),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          key: const Key('primary-action'),
          borderRadius: BorderRadius.circular(8),
          onTapDown: _isTapEnabled ? onTapDown : null,
          child: Center(
            child: Text(
              _label(),
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

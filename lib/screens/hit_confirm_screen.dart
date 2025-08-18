import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hit_confirm/models/enums.dart';
import 'package:hit_confirm/widgets/primary_action_button.dart';
import 'package:hit_confirm/widgets/settings_panel.dart';
import 'package:hit_confirm/widgets/stats_card.dart';

class HitConfirmScreen extends StatefulWidget {
  const HitConfirmScreen({super.key});

  @override
  State<HitConfirmScreen> createState() => _HitConfirmScreenState();
}

class _HitConfirmScreenState extends State<HitConfirmScreen> {
  GameState _gameState = GameState.waiting;
  IconColor _iconColor = IconColor.neutral;

  // 設定
  double _reactionFrames = 30.0;   // 反応可能フレーム数（30F ≈ 0.5s）
  double _colorChangeFrames = 30.0; // 色変化タイミング（30F ≈ 0.5s）

  // 統計
  int _totalAttempts = 0;
  int _successCount = 0;
  int _consecutiveSuccess = 0;
  int _maxConsecutiveSuccess = 0;

  // ゲーム制御
  Timer? _gameTimer;
  Timer? _reactionTimer;
  DateTime? _colorChangeTime;
  final Random _random = Random();

  // 結果表示
  String _resultMessage = '';
  int? _reactionTimeMs;

  @override
  void dispose() {
    _gameTimer?.cancel();
    _reactionTimer?.cancel();
    super.dispose();
  }

  // ===== ゲーム進行 =====

  void _startGame() {
    if (_gameState != GameState.waiting) return;

    setState(() {
      _gameState = GameState.ready;
      _iconColor = IconColor.neutral;
      _resultMessage = '';
      _reactionTimeMs = null;
    });

    // 設定したフレーム数後に色を変化させる（フレーム × 16.67ms）
    final delayMs = (_colorChangeFrames * 16.67).round();
    _gameTimer?.cancel();
    _gameTimer = Timer(Duration(milliseconds: delayMs), _changeColor);
  }

  void _changeColor() {
    if (_gameState != GameState.ready) return;

    final isHit = _random.nextBool();
    _colorChangeTime = DateTime.now();

    setState(() {
      _gameState = GameState.active;
      _iconColor = isHit ? IconColor.hit : IconColor.guard;
    });

    // 反応時間制限（フレーム × 16.67ms）
    final reactionTimeMs = (_reactionFrames * 16.67).round();
    _reactionTimer?.cancel();
    _reactionTimer = Timer(Duration(milliseconds: reactionTimeMs), _timeOut);
  }

  void _onAttackPressed() {
    if (_gameState != GameState.active) return;

    _reactionTimer?.cancel();

    final reactionTime =
        DateTime.now().difference(_colorChangeTime!).inMilliseconds;
    final wasHit = _iconColor == IconColor.hit;
    final wasCorrect = wasHit; // 黄色（ヒット）の時に押すのが正解

    _totalAttempts++;

    setState(() {
      _gameState = GameState.result;
      _reactionTimeMs = reactionTime;

      if (wasCorrect) {
        _successCount++;
        _consecutiveSuccess++;
        if (_consecutiveSuccess > _maxConsecutiveSuccess) {
          _maxConsecutiveSuccess = _consecutiveSuccess;
        }
        _resultMessage = '成功！ ヒット確認できました';
      } else {
        _consecutiveSuccess = 0;
        _resultMessage = '失敗... ガードされていました';
      }
    });

    // 2秒後に次のラウンドへ
    Timer(const Duration(seconds: 2), _resetGame);
  }

  void _timeOut() {
    if (_gameState != GameState.active) return;

    final wasHit = _iconColor == IconColor.hit;
    _totalAttempts++;

    setState(() {
      _gameState = GameState.result;
      // ガードの時に押さないのが正解
      if (!wasHit) {
        _successCount++;
        _consecutiveSuccess++;
        if (_consecutiveSuccess > _maxConsecutiveSuccess) {
          _maxConsecutiveSuccess = _consecutiveSuccess;
        }
        _resultMessage = '正解！ ガードを見切りました';
      } else {
        _consecutiveSuccess = 0;
        _resultMessage = '失敗... ヒット確認できませんでした';
      }
    });

    // 2秒後に次のラウンドへ
    Timer(const Duration(seconds: 2), _resetGame);
  }

  void _resetGame() {
    setState(() {
      _gameState = GameState.waiting;
      _iconColor = IconColor.neutral;
    });
  }

  // ===== UI補助 =====

  Color _getIconColor() {
    switch (_iconColor) {
      case IconColor.neutral:
        return Colors.grey;
      case IconColor.hit:
        return Colors.yellow;
      case IconColor.guard:
        return Colors.blue;
    }
  }

  String _getGameStateText() {
    switch (_gameState) {
      case GameState.waiting:
        return 'スタートボタンを押してください';
      case GameState.ready:
        return '準備中...';
      case GameState.active:
        return _iconColor == IconColor.hit ? '黄色！追撃！' : '青！ガード！';
      case GameState.result:
        return _resultMessage;
    }
  }

  double get _successRate {
    if (_totalAttempts == 0) return 0.0;
    return (_successCount / _totalAttempts) * 100;
  }

  // ===== ビルド =====

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ヒット確認練習'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 設定エリア
              SettingsPanel(
                gameState: _gameState,
                reactionFrames: _reactionFrames,
                colorChangeFrames: _colorChangeFrames,
                onChangeReactionFrames: (v) => setState(() {
                  _reactionFrames = v;
                }),
                onChangeColorChangeFrames: (v) => setState(() {
                  _colorChangeFrames = v;
                }),
              ),

              const SizedBox(height: 20),

              // メインゲームエリア
              SizedBox(
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // アイコン表示
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: _getIconColor(),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                      child: const Icon(
                        Icons.sports_martial_arts,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 状態テキスト
                    Text(
                      _getGameStateText(),
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // コントロールボタン（同じ位置に配置）
                    PrimaryActionButton(
                      gameState: _gameState,
                      onTapDown: (_) => _handlePrimaryPressDown(),
                    ),
                  ],
                ),
              ),

              // 統計表示
              StatsCard(
                successRate: _successRate,
                consecutiveSuccess: _consecutiveSuccess,
                maxConsecutiveSuccess: _maxConsecutiveSuccess,
                totalAttempts: _totalAttempts,
                successCount: _successCount,
                reactionTimeMs: _reactionTimeMs,
                onReset: _resetStats,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== ハンドラ =====

  void _handlePrimaryPressDown() {
    if (_gameState == GameState.waiting) {
      _startGame();           // スタートは押した瞬間
    } else if (_gameState == GameState.active) {
      _onAttackPressed();     // 追撃も押した瞬間
    }
  }

  void _resetStats() {
    setState(() {
      _totalAttempts = 0;
      _successCount = 0;
      _consecutiveSuccess = 0;
      _maxConsecutiveSuccess = 0;
    });
  }
}

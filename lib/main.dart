import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const HitConfirmApp());
}

class HitConfirmApp extends StatelessWidget {
  const HitConfirmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ヒット確認練習',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HitConfirmScreen(),
    );
  }
}

enum GameState {
  waiting,    // 待機中
  ready,      // スタート押下後、色変化待ち
  active,     // 色変化後、入力待ち
  result,     // 結果表示
}

enum IconColor {
  neutral,    // グレー（初期状態）
  hit,        // 黄色（ヒット、追撃可能）
  guard,      // 青（ガード、追撃不可）
}

class HitConfirmScreen extends StatefulWidget {
  const HitConfirmScreen({super.key});

  @override
  State<HitConfirmScreen> createState() => _HitConfirmScreenState();
}

class _HitConfirmScreenState extends State<HitConfirmScreen> {
  GameState _gameState = GameState.waiting;
  IconColor _iconColor = IconColor.neutral;
  
  // 設定
  double _reactionFrames = 30.0; // 反応可能フレーム数（デフォルト30フレーム = 0.5秒）
  double _colorChangeFrames = 30.0; // 色変化タイミング（デフォルト30フレーム = 0.5秒）
  
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

  void _startGame() {
    if (_gameState != GameState.waiting) return;
    
    setState(() {
      _gameState = GameState.ready;
      _iconColor = IconColor.neutral;
      _resultMessage = '';
      _reactionTimeMs = null;
    });

    // 設定したフレーム数後に色を変化させる（フレーム数 × 16.67ms）
    final delayMs = (_colorChangeFrames * 16.67).round();
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

    // 反応時間制限タイマー（フレーム数 × 16.67ms）
    final reactionTimeMs = (_reactionFrames * 16.67).round();
    _reactionTimer = Timer(Duration(milliseconds: reactionTimeMs), _timeOut);
  }

  void _onAttackPressed() {
    if (_gameState != GameState.active) return;

    _reactionTimer?.cancel();
    
    final reactionTime = DateTime.now().difference(_colorChangeTime!).inMilliseconds;
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
        // ガードの時に押さなかった = 正解
        _successCount++;
        _consecutiveSuccess++;
        if (_consecutiveSuccess > _maxConsecutiveSuccess) {
          _maxConsecutiveSuccess = _consecutiveSuccess;
        }
        _resultMessage = '正解！ ガードを見切りました';
      } else {
        // ヒットの時に押さなかった = 失敗
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

  void _resetStats() {
    setState(() {
      _totalAttempts = 0;
      _successCount = 0;
      _consecutiveSuccess = 0;
      _maxConsecutiveSuccess = 0;
    });
  }

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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '反応時間: ${_reactionFrames.round()}F (${(_reactionFrames * 16.67 / 1000).toStringAsFixed(2)}s)',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Slider(
                        value: _reactionFrames,
                        min: 10.0,
                        max: 60.0,
                        divisions: 50,
                        onChanged: _gameState == GameState.waiting
                            ? (value) {
                                setState(() {
                                  _reactionFrames = value;
                                });
                              }
                            : null,
                      ),
                      Text(
                        '色変化: ${_colorChangeFrames.round()}F (${(_colorChangeFrames * 16.67 / 1000).toStringAsFixed(2)}s)',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Slider(
                        value: _colorChangeFrames,
                        min: 1.0,
                        max: 60.0,
                        divisions: 59,
                        onChanged: _gameState == GameState.waiting
                            ? (value) {
                                setState(() {
                                  _colorChangeFrames = value;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
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
                    
                    if (_reactionTimeMs != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        '反応時間: ${_reactionTimeMs}ms',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                    
                    const SizedBox(height: 30),
                    
                    // コントロールボタン（同じ位置に配置）
                    SizedBox(
                      width: 150,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _gameState == GameState.waiting 
                            ? _startGame 
                            : _gameState == GameState.active 
                                ? _onAttackPressed 
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _gameState == GameState.waiting 
                              ? Colors.green 
                              : Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        child: Text(
                          _gameState == GameState.waiting ? 'スタート' : '追撃',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 統計表示
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('統計', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: _resetStats,
                            child: const Text('リセット'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text('${_successRate.toStringAsFixed(1)}%', 
                                   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              const Text('成功率'),
                            ],
                          ),
                          Column(
                            children: [
                              Text('$_consecutiveSuccess', 
                                   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              const Text('連続成功'),
                            ],
                          ),
                          Column(
                            children: [
                              Text('$_maxConsecutiveSuccess', 
                                   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              const Text('最高連続'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('総試行回数: $_totalAttempts回 / 成功: $_successCount回'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

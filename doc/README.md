# ヒット確認アプリ - ドキュメント

このディレクトリには、ヒット確認アプリの設計ドキュメントが含まれています。

## ファイル一覧

### 1. hit_confirm_sequence.puml
ヒット確認アプリのゲームフロー全体を表すシーケンス図です。

**含まれる内容:**
- ユーザーとUI間のインタラクション
- ゲーム状態の遷移
- タイマーの動作
- 成功・失敗・遅延入力の各パターン
- 新機能（timeout状態）の動作フロー

**主要なシナリオ:**
- 通常の成功パターン（時間内にヒット確認）
- 通常の失敗パターン（ガード時の誤入力、ヒット時の無反応）
- 遅延入力パターン（タイムアウト後0.5秒以内の入力）

### 2. game_state_diagram.puml
GameStateの状態遷移を表す状態遷移図です。

**GameState一覧:**
- `waiting`: 待機中（スタートボタン表示）
- `ready`: 準備中（色変化待ち）
- `active`: アクティブ（入力受付中）
- `timeout`: タイムアウト（遅延入力受付中）※新機能
- `result`: 結果表示

**新機能のポイント:**
- `timeout`状態は追撃（黄色）のタイムアウト時のみ発生
- 0.5秒間の遅延入力を受け付ける
- 遅延反応時間も測定・表示される

## PlantUMLの表示方法

### オンラインビューア
1. [PlantUML Online Server](http://www.plantuml.com/plantuml/uml/) にアクセス
2. .pumlファイルの内容をコピー&ペースト
3. 図が生成されます

### VSCode拡張機能
1. "PlantUML" 拡張機能をインストール
2. .pumlファイルを開く
3. `Ctrl+Shift+P` → "PlantUML: Preview Current Diagram" を実行

### ローカル環境
```bash
# Java環境が必要
java -jar plantuml.jar hit_confirm_sequence.puml
java -jar plantuml.jar game_state_diagram.puml
```

## 実装との対応

### 主要メソッド
- `_startGame()`: ゲーム開始処理
- `_changeColor()`: 色変化処理
- `_onAttackPressed()`: 通常の入力処理
- `_onDelayedAttackPressed()`: 遅延入力処理（新機能）
- `_timeOut()`: タイムアウト処理
- `_resetGame()`: ゲームリセット処理

### 新機能の実装ポイント
1. `GameState.timeout`の追加
2. `_delayedInputTimer`による遅延入力タイマー
3. `_onDelayedAttackPressed()`メソッドによる遅延反応時間測定
4. `PrimaryActionButton`でのtimeout状態対応

## 更新履歴
- 2025/8/19: 初版作成
- 2025/8/19: 遅延入力機能追加に伴う図の更新

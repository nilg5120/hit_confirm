# ヒット確認練習アプリ (Hit Confirm Training)

[![Flutter CI](https://github.com/nilg5120/hit_confirm/actions/workflows/ci.yaml/badge.svg)](https://github.com/nilg5120/hit_confirm/actions/workflows/ci.yaml)
[![Flutter Release](https://github.com/nilg5120/hit_confirm/actions/workflows/release.yaml/badge.svg)](https://github.com/nilg5120/hit_confirm/actions/workflows/release.yaml)

格闘ゲームにおけるヒット確認の練習を行うためのFlutterアプリケーションです。

## 概要

このアプリは格闘ゲームプレイヤーがヒット確認スキルを向上させるために開発されました。ランダムに表示される色（ヒット/ガード）に対して適切に反応する練習ができます。

### 主な機能

- **ヒット確認練習**: 黄色（ヒット）の時のみ追撃ボタンを押す練習
- **反応時間測定**: ミリ秒単位での反応時間計測
- **カスタマイズ可能な設定**:
  - 反応可能時間（10-60フレーム）
  - 色変化タイミング（1-60フレーム）
- **詳細な統計情報**:
  - 成功率の表示
  - 連続成功回数
  - 最高連続成功記録
  - 総試行回数

## ゲームルール

1. **スタート**ボタンを押してゲームを開始
2. 設定した時間後に円の色が変化します
   - **黄色（ヒット）**: 追撃ボタンを押す
   - **青色（ガード）**: 何もしない（ボタンを押さない）
3. 設定した反応時間内に正しい判断を行う
4. 結果が表示され、統計が更新されます

## スクリーンショット

### メイン画面
- 大きな円でヒット/ガード状態を表示
- リアルタイムでの反応時間測定
- 直感的な操作インターフェース

### 設定画面
- 反応猶予の調整（フレーム単位）
- 色変化（発生）タイミングの調整
- リアルタイムでの秒数表示

### 統計画面
- 成功率の可視化
- 連続成功記録の追跡
- 詳細な試行データ

## 技術仕様

- **フレームワーク**: Flutter 3.7.2+
- **言語**: Dart
- **対応プラットフォーム**: 
  - Android
  - iOS
  - Web
  - Windows
  - macOS
  - Linux

### 依存関係

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

## インストール・セットアップ

### 前提条件

- Flutter SDK 3.7.2以上
- Dart SDK
- 各プラットフォーム用の開発環境

### 開発環境のセットアップ

1. リポジトリをクローン:
```bash
git clone https://github.com/nilg5120/hit_confirm.git
cd hit_confirm
```

2. 依存関係をインストール:
```bash
flutter pub get
```

3. アプリを実行:
```bash
flutter run
```

### ビルド

#### Android APK
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

#### Windows
```bash
flutter build windows --release
```

## CI/CD

このプロジェクトはGitHub Actionsを使用した自動化されたCI/CDパイプラインを含んでいます。

### 継続的インテグレーション (CI)
- コード品質チェック（`flutter analyze`）
- フォーマットチェック（`flutter format`）
- 自動テスト実行（`flutter test`）
- プルリクエストとmainブランチへのプッシュで実行

### 継続的デプロイメント (CD)
- タグプッシュ時の自動リリース作成
- Android APKの自動ビルドとアップロード
- GitHub Releasesでの配布

### リリース方法

新しいバージョンをリリースするには:

1. バージョンタグを作成:
```bash
git tag v1.0.0
git push origin v1.0.0
```

2. GitHub Actionsが自動的にAPKをビルドし、リリースを作成します

## 開発

### プロジェクト構造

```
lib/
├── main.dart          # メインアプリケーション
└── ...

test/
├── widget_test.dart   # ウィジェットテスト
└── ...

.github/
├── workflows/
│   ├── ci.yaml       # CI設定
│   └── release.yaml  # リリース設定
└── ...
```

### コーディング規約

- Dart公式のlintルールに従う
- `flutter format`でコードフォーマットを統一
- 適切なコメントとドキュメンテーション

### テスト

```bash
# 全テストを実行
flutter test

# 特定のテストファイルを実行
flutter test test/widget_test.dart
```

## CI (GitHub Actions)

- ファイル: `.github/workflows/ci.yml`
- main ブランチへの push / PR で実行されます
- 実行内容:
  1. `dart format --set-exit-if-changed .` （コード整形確認）
  2. `flutter analyze` （静的解析）
  3. `flutter test` （ユニットテスト）

## 貢献

1. このリポジトリをフォーク
2. 機能ブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add some amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## ライセンス

このプロジェクトは私的使用のためのものです（`publish_to: 'none'`）。

## 作者

- GitHub: [@nilg5120](https://github.com/nilg5120)

## 更新履歴

### v1.0.0
- 初回リリース
- 基本的なヒット確認練習機能
- 統計機能
- 設定カスタマイズ機能

---

格闘ゲームのスキル向上にお役立てください！

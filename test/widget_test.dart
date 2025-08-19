import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ← 分割後は app.dart からインポート
import 'package:hit_confirm/app.dart';

void main() {
  testWidgets('ヒット確認アプリのスモークテスト', (WidgetTester tester) async {
    await tester.pumpWidget(const HitConfirmApp());

    expect(find.text('ヒット確認練習'), findsOneWidget);
    expect(find.text('スタートボタンを押してください'), findsOneWidget);
    expect(find.text('スタート'), findsOneWidget);

    expect(find.text('0.0%'), findsOneWidget); // 成功率
    expect(find.text('総試行回数: 0回 / 成功: 0回'), findsOneWidget);
  });

  testWidgets('設定スライダーが動作する', (WidgetTester tester) async {
    await tester.pumpWidget(const HitConfirmApp());

    expect(find.byType(Slider), findsNWidgets(2));
    expect(find.textContaining('反応時間: 30F'), findsOneWidget);
    expect(find.textContaining('色変化: 30F'), findsOneWidget);
  });

  testWidgets('ゲーム状態に応じて単一ボタンが変化する（Key 指定版）', (WidgetTester tester) async {
    await tester.pumpWidget(const HitConfirmApp());

    // 初期表示
    expect(find.text('スタート'), findsOneWidget);
    expect(find.text('追撃'), findsNothing);

    // メインボタンを Key で一意取得
    final button = find.byKey(const Key('primary-action'));
    expect(button, findsOneWidget);

    // 初期色（waiting=緑）
    final materialAt =
        () => tester.widget<Material>(
          find.ancestor(of: button, matching: find.byType(Material)).first,
        );
    expect(materialAt().color, equals(Colors.green));

    // 1タップで waiting→ready（準備中）へ：色=灰、ラベル=「追撃」
    await tester.tap(button); // onTapDown で _startGame()
    await tester.pump(); // setState 反映
    expect(find.text('スタート'), findsNothing);
    expect(find.text('追撃'), findsOneWidget);
    expect(materialAt().color, equals(Colors.grey));

    // 色変化タイマー経過（30F ≈ 500ms）→ active：色=赤、ラベル=「追撃」
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    expect(find.text('追撃'), findsOneWidget);
    expect(materialAt().color, equals(Colors.red));

    // 2タップ目で active→result（結果表示）→ この時点では灰色
    await tester.tap(button); // onTapDown で _onAttackPressed()
    await tester.pump();
    await tester.pumpAndSettle();
    expect(materialAt().color, equals(Colors.grey));

    // 2秒タイマーを消化して未処理タイマーをなくす
    await tester.pump(const Duration(seconds: 3)); // 2秒より長く進める
    await tester.pumpAndSettle();
  });
}

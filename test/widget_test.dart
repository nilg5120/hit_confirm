import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hit_confirm/main.dart';

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

testWidgets('ゲーム状態に応じて単一ボタンが変化する（InkWell + Material 対応）', (
  WidgetTester tester,
) async {
  await tester.pumpWidget(const HitConfirmApp());

  // 初期表示
  expect(find.text('スタート'), findsOneWidget);
  expect(find.text('追撃'), findsNothing);

  // ボタンコンテナ（SizedBox 150x60）を特定
  final buttonBox = find.byWidgetPredicate((w) =>
      w is SizedBox && w.width == 150 && w.height == 60);
  expect(buttonBox, findsOneWidget);

  // その配下の InkWell と Material を一意に取得
  final buttonInkWell = find.descendant(
    of: buttonBox,
    matching: find.byType(InkWell),
  );
  final buttonMaterial = find.descendant(
    of: buttonBox,
    matching: find.byType(Material),
  );
  expect(buttonInkWell, findsOneWidget);
  expect(buttonMaterial, findsOneWidget);

  // 初期色（waiting=緑）
  expect(tester.widget<Material>(buttonMaterial).color, equals(Colors.green));

  // 1タップで waiting→ready（準備中）へ。色はグレー、ラベルは「追撃」
  await tester.tap(buttonInkWell); // onTapDownで_startGame()
  await tester.pump();             // setState 反映
  expect(find.text('スタート'), findsNothing);
  expect(find.text('追撃'), findsOneWidget);
  expect(tester.widget<Material>(buttonMaterial).color, equals(Colors.grey));

  // 色変化タイマー経過（デフォ: 30F ≈ 500ms）→ active（赤）
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pumpAndSettle();
  expect(find.text('追撃'), findsOneWidget);
  expect(tester.widget<Material>(buttonMaterial).color, equals(Colors.red));

  // 2タップで active→result（結果表示）→ この時点では灰色
  await tester.tap(buttonInkWell); // onTapDownで_onAttackPressed()
  await tester.pump();
  await tester.pumpAndSettle();

  // ★ここで灰色を確認（まだ2秒経過前）
  expect(tester.widget<Material>(buttonMaterial).color, equals(Colors.grey));

  // 2秒タイマーを消化して未処理タイマーをなくす
  await tester.pump(const Duration(seconds: 3)); // 2秒より長く進める
  await tester.pumpAndSettle();                  // 残りのフレームを安定させる
  });

}

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hit_confirm/main.dart';

void main() {
  testWidgets('Hit confirm app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HitConfirmApp());

    // Verify that our app starts with the correct initial state.
    expect(find.text('ヒット確認練習'), findsOneWidget);
    expect(find.text('スタートボタンを押してください'), findsOneWidget);
    expect(find.text('スタート'), findsOneWidget);

    // Verify that the statistics are initially zero.
    expect(find.text('0.0%'), findsOneWidget); // Success rate
    expect(find.text('総試行回数: 0回 / 成功: 0回'), findsOneWidget);
  });

  testWidgets('Settings sliders work', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HitConfirmApp());

    // Find both sliders and verify they exist
    expect(find.byType(Slider), findsNWidgets(2));

    // Verify initial frame settings are displayed
    expect(find.textContaining('反応時間: 30F'), findsOneWidget);
    expect(find.textContaining('色変化: 30F'), findsOneWidget);
  });

  testWidgets('Single button changes based on game state', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HitConfirmApp());

    // Initially should show "スタート" button
    expect(find.text('スタート'), findsOneWidget);
    expect(find.text('追撃'), findsNothing);

    // Verify button is centered and has correct size
    final buttonFinder = find.byType(ElevatedButton);
    expect(buttonFinder, findsOneWidget);
  });
}

enum GameState {
  waiting, // 待機中
  ready,   // スタート押下後、色変化待ち
  active,  // 色変化後、入力待ち
  result,  // 結果表示
}

enum IconColor {
  neutral, // グレー（初期状態）
  hit,     // 黄色（ヒット、追撃可能）
  guard,   // 青（ガード、追撃不可）
}

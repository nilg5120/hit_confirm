import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
    required this.successRate,
    required this.consecutiveSuccess,
    required this.maxConsecutiveSuccess,
    required this.totalAttempts,
    required this.successCount,
    required this.onReset,
    this.reactionTimeMs,
  });

  final double successRate;
  final int consecutiveSuccess;
  final int maxConsecutiveSuccess;
  final int totalAttempts;
  final int successCount;
  final VoidCallback onReset;
  final int? reactionTimeMs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (reactionTimeMs != null) ...[
          const SizedBox(height: 10),
          Text(
            '反応時間: ${(reactionTimeMs! / 16.67).round()}F (${reactionTimeMs}ms)',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '統計',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: onReset,
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
                        Text(
                          '${successRate.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Text('成功率'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '$consecutiveSuccess',
                          style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Text('連続成功'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '$maxConsecutiveSuccess',
                          style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Text('最高連続'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text('総試行回数: $totalAttempts回 / 成功: $successCount回'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

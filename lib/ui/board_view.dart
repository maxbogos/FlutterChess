import 'package:flutter/material.dart';
import '../../models/position.dart';
import 'square_view.dart';

/// The main chess board widget
class BoardView extends StatelessWidget {
  const BoardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Column labels (a-h)
    final colLabels = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

    return Column(
      children: [
        // Top column labels
        SizedBox(
          height: 30,
          child: Row(
            children: [
              const SizedBox(width: 30), // Space for row labels
              ...colLabels.map((label) => SizedBox(
                width: 60,
                child: Center(
                  child: Text(
                    label.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),

        // Board rows
        for (int row = 0; row < 8; row++)
          Row(
            children: [
              // Row label (8-1)
              SizedBox(
                width: 30,
                child: Center(
                  child: Text(
                    '${8 - row}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              // Squares in this row
              for (int col = 0; col < 8; col++)
                SizedBox(
                  width: 60,
                  height: 60,
                  child: SquareView(position: Position(row, col)),
                ),
            ],
          ),

        // Bottom column labels
        SizedBox(
          height: 30,
          child: Row(
            children: [
              const SizedBox(width: 30),
              ...colLabels.map((label) => SizedBox(
                width: 60,
                child: Center(
                  child: Text(
                    label.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}

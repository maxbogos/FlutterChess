import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/chess_engine.dart';
import '../../models/piece.dart';
import '../../models/position.dart';

/// Individual square on the chess board
class SquareView extends StatelessWidget {
  final Position position;

  const SquareView({
    super.key,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final engine = context.watch<ChessEngine>();
    final board = engine.board;
    final piece = board.at(position);
    final isLight = (position.row + position.col) % 2 == 0;

    // Determine background color
    Color backgroundColor;
    if (engine.selectedPosition == position) {
      backgroundColor = Colors.yellow.shade300; // Selected piece highlight
    } else if (engine.legalMoves.contains(position)) {
      backgroundColor = Colors.green.shade300; // Legal move highlight
    } else if (isLight) {
      backgroundColor = Colors.grey.shade200;
    } else {
      backgroundColor = Colors.blueGrey.shade700;
    }

    // Check if king is in check
    bool isKingInCheck = false;
    if (piece?.type == PieceType.king && engine.gameStatus == GameStatus.check) {
      if (piece!.color == engine.currentTurn) {
        isKingInCheck = true;
      }
    }

    return GestureDetector(
      onTap: () => engine.onSquareTapped(position),
      child: Container(
        decoration: BoxDecoration(
          color: isKingInCheck ? Colors.red.shade400 : backgroundColor,
          border: Border.all(
            color: Colors.blueGrey.shade900,
            width: 0.5,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Piece
            if (piece != null)
              Text(
                piece.symbol,
                style: TextStyle(
                  fontSize: 40,
                  color: piece.color == PieceColor.white
                      ? Colors.white
                      : Colors.black87,
                  shadows: [
                    Shadow(
                      blurRadius: 2,
                      color: Colors.black54,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
            // Legal move indicator (dot for empty squares)
            if (engine.legalMoves.contains(position) && piece == null)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.green.shade700.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

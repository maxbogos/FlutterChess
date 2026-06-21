import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/chess_engine.dart';
import '../../models/piece.dart';

/// Panel showing game info, captured pieces, and controls
class GameInfoPanel extends StatelessWidget {
  const GameInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final engine = context.watch<ChessEngine>();

    return Card(
      color: Colors.white.withOpacity(0.95),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Game Status
            _buildStatusSection(engine),

            const SizedBox(height: 16),

            // Turn Indicator
            _buildTurnIndicator(engine),

            const SizedBox(height: 16),

            // Captured Pieces
            _buildCapturedPieces(engine),

            const SizedBox(height: 16),

            // Move Count
            Text(
              'Moves: ${engine.moveHistory.length}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            // Reset Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: engine.resetGame,
                icon: const Icon(Icons.refresh),
                label: const Text('New Game'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(ChessEngine engine) {
    IconData statusIcon;
    Color statusColor;

    switch (engine.gameStatus) {
      case GameStatus.playing:
        statusIcon = Icons.play_arrow;
        statusColor = Colors.green;
        break;
      case GameStatus.check:
        statusIcon = Icons.warning_amber;
        statusColor = Colors.orange;
        break;
      case GameStatus.checkmate:
        statusIcon = Icons.emoji_events;
        statusColor = Colors.red;
        break;
      case GameStatus.stalemate:
        statusIcon = Icons.draw;
        statusColor = Colors.grey;
        break;
      default:
        statusIcon = Icons.gamepad;
        statusColor = Colors.blue;
    }

    return Row(
      children: [
        Icon(statusIcon, color: statusColor, size: 28),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            engine.statusMessage,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTurnIndicator(ChessEngine engine) {
    return Row(
      children: [
        const Text(
          'Current Turn:',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(width: 8),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: engine.currentTurn == PieceColor.white
                ? Colors.white
                : Colors.black87,
            border: Border.all(color: Colors.grey, width: 1),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          engine.currentTurn == PieceColor.white ? 'White' : 'Black',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildCapturedPieces(ChessEngine engine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // White captured (pieces taken by white, so black pieces)
        if (engine.capturedBlack.isNotEmpty) ...[
          const Text(
            'White captured:',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 2,
            children: engine.capturedBlack
                .map((piece) => Text(
                      piece.symbol,
                      style: const TextStyle(fontSize: 20),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
        ],
        // Black captured (pieces taken by black, so white pieces)
        if (engine.capturedWhite.isNotEmpty) ...[
          const Text(
            'Black captured:',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 2,
            children: engine.capturedWhite
                .map((piece) => Text(
                      piece.symbol,
                      style: const TextStyle(fontSize: 20),
                    ))
                .toList(),
          ),
        ],
        if (engine.capturedWhite.isEmpty && engine.capturedBlack.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'No captures yet',
              style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
      ],
    );
  }
}

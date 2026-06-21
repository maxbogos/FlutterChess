import '../models/board.dart';
import '../models/move.dart';
import '../models/piece.dart';
import '../models/position.dart';

/// Generates all possible moves for pieces (raw moves, not yet validated for check)
class MoveGenerator {
  final Board board;

  MoveGenerator(this.board);

  /// Get all raw moves for a given color
  List<Move> generateAllMoves(PieceColor color) {
    final moves = <Move>[];

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = board.at(Position(row, col));
        if (piece != null && piece.color == color) {
          moves.addAll(_generateMovesForPiece(Position(row, col), piece));
        }
      }
    }

    return moves;
  }

  /// Get all raw moves for a specific piece
  List<Move> _generateMovesForPiece(Position pos, Piece piece) {
    switch (piece.type) {
      case PieceType.pawn:
        return _generatePawnMoves(pos, piece);
      case PieceType.knight:
        return _generateKnightMoves(pos, piece);
      case PieceType.bishop:
        return _generateBishopMoves(pos, piece);
      case PieceType.rook:
        return _generateRookMoves(pos, piece);
      case PieceType.queen:
        return _generateQueenMoves(pos, piece);
      case PieceType.king:
        return _generateKingMoves(pos, piece);
    }
  }

  // --- PAWN MOVES ---
  List<Move> _generatePawnMoves(Position pos, Piece piece) {
    final moves = <Move>[];
    final direction = piece.color == PieceColor.white ? -1 : 1;
    final startRow = piece.color == PieceColor.white ? 6 : 1;

    // Move forward one square
    final oneAhead = Position(pos.row + direction, pos.col);
    if (_isEmpty(oneAhead)) {
      moves.add(Move(from: pos, to: oneAhead));

      // Move forward two squares from starting position
      if (pos.row == startRow) {
        final twoAhead = Position(pos.row + 2 * direction, pos.col);
        if (_isEmpty(twoAhead)) {
          moves.add(Move(from: pos, to: twoAhead));
        }
      }
    }

    // Capture diagonally
    for (int colOffset = -1; colOffset <= 1; colOffset += 2) {
      final capturePos = Position(pos.row + direction, pos.col + colOffset);
      if (capturePos.isValid()) {
        final targetPiece = board.at(capturePos);
        if (targetPiece != null && targetPiece.color != piece.color) {
          moves.add(Move(from: pos, to: capturePos, capturedPiece: targetPiece));
        }
      }
    }

    return moves;
  }

  // --- KNIGHT MOVES ---
  List<Move> _generateKnightMoves(Position pos, Piece piece) {
    final moves = <Move>[];
    final offsets = [
      const Position(-2, -1), const Position(-2, 1),
      const Position(-1, -2), const Position(-1, 2),
      const Position(1, -2),  const Position(1, 2),
      const Position(2, -1),  const Position(2, 1),
    ];

    for (final offset in offsets) {
      final newPos = pos + offset;
      if (_isValidTarget(newPos, piece.color)) {
        final targetPiece = board.at(newPos);
        moves.add(Move(from: pos, to: newPos, capturedPiece: targetPiece));
      }
    }

    return moves;
  }

  // --- BISHOP MOVES ---
  List<Move> _generateBishopMoves(Position pos, Piece piece) {
    final moves = <Move>[];
    final directions = [
      const Position(-1, -1), const Position(-1, 1),
      const Position(1, -1),  const Position(1, 1),
    ];

    for (final dir in directions) {
      moves.addAll(_generateSlidingMoves(pos, dir, piece.color));
    }

    return moves;
  }

  // --- ROOK MOVES ---
  List<Move> _generateRookMoves(Position pos, Piece piece) {
    final moves = <Move>[];
    final directions = [
      const Position(-1, 0), const Position(1, 0),
      const Position(0, -1), const Position(0, 1),
    ];

    for (final dir in directions) {
      moves.addAll(_generateSlidingMoves(pos, dir, piece.color));
    }

    return moves;
  }

  // --- QUEEN MOVES ---
  List<Move> _generateQueenMoves(Position pos, Piece piece) {
    final moves = <Move>[];
    final directions = [
      const Position(-1, -1), const Position(-1, 0), const Position(-1, 1),
      const Position(0, -1),                          const Position(0, 1),
      const Position(1, -1),  const Position(1, 0),  const Position(1, 1),
    ];

    for (final dir in directions) {
      moves.addAll(_generateSlidingMoves(pos, dir, piece.color));
    }

    return moves;
  }

  // --- KING MOVES ---
  List<Move> _generateKingMoves(Position pos, Piece piece) {
    final moves = <Move>[];
    final directions = [
      const Position(-1, -1), const Position(-1, 0), const Position(-1, 1),
      const Position(0, -1),                          const Position(0, 1),
      const Position(1, -1),  const Position(1, 0),  const Position(1, 1),
    ];

    for (final dir in directions) {
      final newPos = pos + dir;
      if (_isValidTarget(newPos, piece.color)) {
        final targetPiece = board.at(newPos);
        moves.add(Move(from: pos, to: newPos, capturedPiece: targetPiece));
      }
    }

    return moves;
  }

  // --- SLIDING PIECES (Bishop, Rook, Queen) ---
  List<Move> _generateSlidingMoves(Position pos, Position direction, PieceColor color) {
    final moves = <Move>[];

    var currentPos = pos + direction;
    while (currentPos.isValid()) {
      final targetPiece = board.at(currentPos);

      if (targetPiece == null) {
        // Empty square, can move here
        moves.add(Move(from: pos, to: currentPos));
      } else if (targetPiece.color != color) {
        // Enemy piece, can capture
        moves.add(Move(from: pos, to: currentPos, capturedPiece: targetPiece));
        break;
      } else {
        // Friendly piece, blocked
        break;
      }

      currentPos = currentPos + direction;
    }

    return moves;
  }

  /// Check if a position is empty
  bool _isEmpty(Position pos) {
    return pos.isValid() && board.at(pos) == null;
  }

  /// Check if a position is a valid target (empty or enemy piece)
  bool _isValidTarget(Position pos, PieceColor color) {
    if (!pos.isValid()) return false;
    final piece = board.at(pos);
    return piece == null || piece.color != color;
  }
}

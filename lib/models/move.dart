import 'piece.dart';
import 'position.dart';

/// Represents a chess move
class Move {
  final Position from;
  final Position to;
  final Piece? capturedPiece;
  final Piece? promotionPiece;
  final bool isCastling;
  final bool isEnPassant;
  final bool isCheck;
  final bool isCheckmate;

  Move({
    required this.from,
    required this.to,
    this.capturedPiece,
    this.promotionPiece,
    this.isCastling = false,
    this.isEnPassant = false,
    this.isCheck = false,
    this.isCheckmate = false,
  });

  /// Convert move to algebraic notation
  String toAlgebraic() {
    String notation = '';
    
    // Add piece symbol (except for pawns)
    // This would need access to the piece, so we'll keep it simple
    notation += from.toAlgebraic();
    notation += ' → ';
    notation += to.toAlgebraic();
    
    if (isCheckmate) {
      notation += '#';
    } else if (isCheck) {
      notation += '+';
    }
    
    return notation;
  }

  @override
  String toString() => 'Move(${from.toAlgebraic()} → ${to.toAlgebraic()})';
}

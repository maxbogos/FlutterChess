/// Represents the two colors in chess
enum PieceColor { white, black }

/// Represents the type of chess piece
enum PieceType {
  king,
  queen,
  rook,
  bishop,
  knight,
  pawn,
}

/// Represents a chess piece on the board
class Piece {
  final PieceType type;
  final PieceColor color;
  bool hasMoved;

  Piece({
    required this.type,
    required this.color,
    this.hasMoved = false,
  });

  /// Returns the Unicode symbol for the piece
  String get symbol {
    switch (type) {
      case PieceType.king:
        return color == PieceColor.white ? '♔' : '♚';
      case PieceType.queen:
        return color == PieceColor.white ? '♕' : '♛';
      case PieceType.rook:
        return color == PieceColor.white ? '♖' : '♜';
      case PieceType.bishop:
        return color == PieceColor.white ? '♗' : '♝';
      case PieceType.knight:
        return color == PieceColor.white ? '♘' : '♞';
      case PieceType.pawn:
        return color == PieceColor.white ? '♙' : '♟';
    }
  }

  @override
  String toString() => '${color.name} ${type.name}';
}

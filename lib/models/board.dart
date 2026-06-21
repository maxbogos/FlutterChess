import 'piece.dart';
import 'position.dart';

/// Represents the 8x8 chess board
class Board {
  final List<List<Piece?>> _squares = List.generate(
    8,
    (_) => List<Piece?>.filled(8, null),
  );

  /// Get piece at a position (null if empty)
  Piece? at(Position pos) {
    if (!pos.isValid()) return null;
    return _squares[pos.row][pos.col];
  }

  /// Set a piece at a position
  void set(Position pos, Piece? piece) {
    if (pos.isValid()) {
      _squares[pos.row][pos.col] = piece;
    }
  }

  /// Move a piece from one position to another
  void move(Position from, Position to) {
    final piece = _squares[from.row][from.col];
    _squares[from.row][from.col] = null;
    _squares[to.row][to.col] = piece;
    piece?.hasMoved = true;
  }

  /// Find the position of a king for a given color
  Position? findKing(PieceColor color) {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = _squares[row][col];
        if (piece?.type == PieceType.king && piece?.color == color) {
          return Position(row, col);
        }
      }
    }
    return null;
  }

  /// Check if a position is attacked by a specific color
  bool isAttackedBy(Position pos, PieceColor color) {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = _squares[row][col];
        if (piece != null && piece.color == color) {
          final attackerPos = Position(row, col);
          if (_canAttack(piece, attackerPos, pos)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  /// Check if a piece can attack a specific position
  bool _canAttack(Piece piece, Position from, Position to) {
    final rowDiff = to.row - from.row;
    final colDiff = to.col - from.col;
    final absRowDiff = rowDiff.abs();
    final absColDiff = colDiff.abs();

    switch (piece.type) {
      case PieceType.pawn:
        final direction = piece.color == PieceColor.white ? -1 : 1;
        return rowDiff == direction && absColDiff == 1;

      case PieceType.knight:
        return (absRowDiff == 2 && absColDiff == 1) ||
            (absRowDiff == 1 && absColDiff == 2);

      case PieceType.bishop:
        if (absRowDiff != absColDiff) return false;
        return _isPathClear(from, to);

      case PieceType.rook:
        if (rowDiff != 0 && colDiff != 0) return false;
        return _isPathClear(from, to);

      case PieceType.queen:
        if (rowDiff != 0 && colDiff != 0 && absRowDiff != absColDiff) return false;
        return _isPathClear(from, to);

      case PieceType.king:
        return absRowDiff <= 1 && absColDiff <= 1 && (absRowDiff + absColDiff > 0);
    }
  }

  /// Check if the path between two positions is clear
  bool _isPathClear(Position from, Position to) {
    final rowStep = from.row == to.row ? 0 : (to.row - from.row).abs() ~/ (to.row - from.row);
    final colStep = from.col == to.col ? 0 : (to.col - from.col).abs() ~/ (to.col - from.col);

    var currentRow = from.row + rowStep;
    var currentCol = from.col + colStep;

    while (currentRow != to.row || currentCol != to.col) {
      if (_squares[currentRow][currentCol] != null) return false;
      currentRow += rowStep;
      currentCol += colStep;
    }
    return true;
  }

  /// Create a deep copy of the board
  Board clone() {
    final newBoard = Board();
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = _squares[row][col];
        if (piece != null) {
          newBoard.set(
            Position(row, col),
            Piece(type: piece.type, color: piece.color, hasMoved: piece.hasMoved),
          );
        }
      }
    }
    return newBoard;
  }

  /// Initialize the board with starting positions
  void setupInitialPosition() {
    // Clear the board
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        _squares[row][col] = null;
      }
    }

    // Set up pawns
    for (int col = 0; col < 8; col++) {
      _squares[1][col] = Piece(type: PieceType.pawn, color: PieceColor.black);
      _squares[6][col] = Piece(type: PieceType.pawn, color: PieceColor.white);
    }

    // Set up back ranks
    final pieceOrder = [
      PieceType.rook,
      PieceType.knight,
      PieceType.bishop,
      PieceType.queen,
      PieceType.king,
      PieceType.bishop,
      PieceType.knight,
      PieceType.rook,
    ];

    for (int col = 0; col < 8; col++) {
      _squares[0][col] = Piece(type: pieceOrder[col], color: PieceColor.black);
      _squares[7][col] = Piece(type: pieceOrder[col], color: PieceColor.white);
    }
  }
}

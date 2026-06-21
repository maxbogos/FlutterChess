import '../models/board.dart';
import '../models/move.dart';
import '../models/piece.dart';
import 'move_generator.dart';

/// Filters moves to ensure the king is never left in check
class MoveValidator {
  final Board board;

  MoveValidator(this.board);

  /// Get all legal moves for a color (filters out moves that leave king in check)
  List<Move> getLegalMoves(PieceColor color) {
    return getAllLegalMoves(board, color);
  }

  /// Check if a color is currently in check
  static bool isInCheck(Board board, PieceColor color) {
    final kingPos = board.findKing(color);
    if (kingPos == null) return false;

    final enemyColor = color == PieceColor.white ? PieceColor.black : PieceColor.white;
    return board.isAttackedBy(kingPos, enemyColor);
  }

  /// Check if a color is in checkmate
  static bool isCheckmate(Board board, PieceColor color) {
    if (!isInCheck(board, color)) return false;
    return getAllLegalMoves(board, color).isEmpty;
  }

  /// Check if a color is in stalemate
  static bool isStalemate(Board board, PieceColor color) {
    if (isInCheck(board, color)) return false;
    return getAllLegalMoves(board, color).isEmpty;
  }

  /// Get all legal moves for a color on a given board
  static List<Move> getAllLegalMoves(Board board, PieceColor color) {
    final rawMoves = MoveGenerator(board).generateAllMoves(color);
    return rawMoves.where((move) {
      final clonedBoard = board.clone();
      final piece = clonedBoard.at(move.from);
      if (piece == null) return false;

      clonedBoard.move(move.from, move.to);

      final kingPos = clonedBoard.findKing(piece.color);
      if (kingPos == null) return false;

      final enemyColor = piece.color == PieceColor.white ? PieceColor.black : PieceColor.white;
      return !clonedBoard.isAttackedBy(kingPos, enemyColor);
    }).toList();
  }
}


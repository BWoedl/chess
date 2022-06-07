# frozen_string_literal: true

module Messages
  INVALID_PIECE = "Try again with a valid position! Select one of your pieces only\n"
  INVALID_TARGET = "Try again with a valid position! It must be on the board\n"
  OBTAIN_TARGET_SPOT = "\nNow put the column and row of the spot you'd like to move to. Ex: b4"
  ILLEGAL_MOVE = "That's an illegal move for your piece. Try again!"
  OBTAIN_TARGET_PIECE = ", please put the column and row of the piece you'd like to move. Ex: a4"
  CHECK = 'king is now in check'
  PROMOTION_PROMPT = 'Which piece would you like to swap your pawn for? Type Queen, Bishop, Rook, or Knight'
  INVALID_PROMOTION_PROMPT = "That's not a valid option! Which piece would you like to swap your pawn for? Type Queen, Bishop, Rook, or Knight"
  GAME_END = 'Game over!'
  STALEMATE = "\nThere are no possible moves left. The game is a stalemate."
  CHECK_MATE = 'you won! It is checkmate.'
end

# frozen_string_literal: true

require 'pawn'

describe Pawn do
  describe '.legal_move? for white pawn' do
    context 'moves one space forward' do
      it 'returns false' do
        expect(Pawn.legal_move?([3, 3], [4, 3])).to be(true)
      end
    end
    context 'moves two spaces on the first move' do
      it 'returns true' do
        expect(Pawn.legal_move?([4, 3], [5, 3])).to be(true)
      end
    end
    context 'moves two spaces on a move besides the first' do
      it 'returns false' do
        #move count > 1
        expect(Pawn.legal_move?([4, 3], [5, 3])).to be(false)
      end
    context 'moves diagonally when no piece in the target spot' do
      it 'returns false' do
        #target spot empty
        expect(Pawn.legal_move?([4, 3], [5, 4])).to be(false)
      end
    end
    context 'moves diagonally when a piece in the target spot' do
      it 'returns true' do
        # target spot occupied
        expect(Pawn.legal_move?([4, 3], [5, 4])).to be(true)
      end
    end
    context 'moves diagonally more than one row' do
      it 'returns false' do
        # target spot occupied
        expect(Pawn.legal_move?([4, 3], [6, 5])).to be(false)
      end
    end
    context 'moves forward more than two spaces' do
      it 'returns false' do
        # first move
        expect(Pawn.legal_move?([4, 3], [7, 3])).to be(false)
      end
    end
    context 'moves backward' do
      it 'returns false' do
        expect(Pawn.legal_move?([4, 3], [3, 3])).to be(false)
      end
    end
    describe '.legal_move? for black pawn' do
      context 'moves backward' do
        it 'returns false' do
          expect(Pawn.legal_move?([4, 3], [5, 3])).to be(false)
        end
      end
    end
  end
end

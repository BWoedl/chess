# frozen_string_literal: true

require 'king'

describe King do
  describe '.legal_move' do
    context 'moves two spaces' do
      it 'returns false' do
        expect(King.legal_move?([3, 3], [5, 3])).to be(false)
      end
    end
    context 'moves one space to the side' do
      it 'returns true' do
        expect(King.legal_move?([4, 3], [4, 4])).to be(true)
      end
    end
    context 'moves one space diagonally' do
      it 'returns true' do
        expect(King.legal_move?([4, 3], [5, 4])).to be(true)
      end
    end
  end
end

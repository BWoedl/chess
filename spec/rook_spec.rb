# frozen_string_literal: true

require 'piece'
require 'rook'

describe Rook do
  describe '.legal_move' do
    context 'moves diagonally' do
      it 'returns false' do
        expect(Rook.legal_move?([4, 3], [5, 4])).to be(false)
      end
    end
    context 'moves one space to the side' do
      it 'returns true' do
        expect(Rook.legal_move?([4, 3], [4, 4])).to be(true)
      end
    end
    context 'moves multiple spaces to the side' do
      it 'returns true' do
        expect(Rook.legal_move?([1, 3], [7, 3])).to be(true)
      end
    end
  end
end

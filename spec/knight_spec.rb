# frozen_string_literal: true

require 'piece'
require 'knight'

describe Knight do
  xdescribe '.legal_move' do
    context 'moves two spaces up and one to the side' do
      it 'returns true' do
        expect(Knight.legal_move?([3, 3], [5, 4])).to be(true)
      end
    end
    context 'moves two spaces to the side and one down' do
      it 'returns true' do
        expect(Knight.legal_move?([4, 3], [3, 5])).to be(true)
      end
    end
    context 'moves diagonally' do
      it 'returns false' do
        expect(Knight.legal_move?([4, 3], [7, 6])).to be(false)
      end
    end
    context 'moves to the side' do
      it 'returns false' do
        expect(Knight.legal_move?([4, 3], [4, 4])).to be(false)
      end
    end
  end
end

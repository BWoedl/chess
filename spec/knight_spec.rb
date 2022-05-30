# frozen_string_literal: true

require 'piece'
require 'knight'

describe Knight do
  subject(:knight) { Knight.new('white') }
  let(:board) { double('board') }
  let(:queen) { double('queen', color: 'white') }
  let(:rook) { double('rook', color: 'black') }

  describe '.legal_move' do
    context 'moves two spaces up and one to the side' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(subject.legal_move?(board, [3, 3], [5, 4])).to be(true)
      end
    end
    context 'moves two spaces to the side and one down' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(subject.legal_move?(board, [4, 3], [3, 5])).to be(true)
      end
    end
    context 'moves diagonally' do
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(subject.legal_move?(board, [4, 3], [7, 6])).to be(false)
      end
    end
    context 'moves to the side' do
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(subject.legal_move?(board, [4, 3], [4, 4])).to be(false)
      end
    end
    context 'tries to move to a spot with another white piece' do
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(queen)
        expect(subject.legal_move?(board, [2, 1], [1, 3])).to be(false)
      end
    end
    context 'is allowed to move to a spot with a black piece' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(rook)
        expect(subject.legal_move?(board, [4, 3], [3, 5])).to be(true)
      end
    end
  end
end

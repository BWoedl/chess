# frozen_string_literal: true

require 'piece'
require 'queen'

describe Queen do
  subject(:queen) { Queen.new('white') }
  let(:board) { double('board') }

  describe '.legal_move' do
    context 'moves two spaces up and one to the side' do
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(subject.legal_move?(board, [3, 3], [5, 4])).to be(false)
      end
    end
    context 'moves to the side' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(subject.legal_move?(board, [4, 3], [4, 7])).to be(true)
      end
    end
    context 'moves diagonally' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(subject.legal_move?(board, [4, 3], [7, 6])).to be(true)
      end
    end
  end
end

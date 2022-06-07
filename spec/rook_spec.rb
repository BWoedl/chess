# frozen_string_literal: true

require 'piece'
require 'rook'

describe Rook do
  subject(:Rook) { Rook.new('white') }
  let(:board) { double('board') }

  describe '.legal_move' do
    context 'moves diagonally' do
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        allow(board).to receive(:occupied_by_same_color?).and_return(false)
        expect(subject.legal_move?(board, [4, 3], [5, 4])).to be(false)
      end
    end
    context 'moves one space to the side' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        allow(board).to receive(:occupied_by_same_color?).and_return(false)
        expect(subject.legal_move?(board, [4, 3], [4, 4])).to be(true)
      end
    end
    context 'moves multiple spaces to the side' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        allow(board).to receive(:occupied_by_same_color?).and_return(false)
        expect(subject.legal_move?(board, [1, 3], [7, 3])).to be(true)
      end
    end
  end
end

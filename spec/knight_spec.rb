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
        allow(board).to receive(:occupied_by_same_color?).and_return(false)
        expect(subject.legal_move?(board, [3, 3], [5, 4])).to be(true)
      end
    end
    context 'moves two spaces to the side and one down' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        allow(board).to receive(:occupied_by_same_color?).and_return(false)
        expect(subject.legal_move?(board, [4, 3], [3, 5])).to be(true)
      end
    end
    context 'moves diagonally' do
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        allow(board).to receive(:occupied_by_same_color?).and_return(false)
        expect(subject.legal_move?(board, [4, 3], [7, 6])).to be(false)
      end
    end
    context 'moves to the side' do
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        allow(board).to receive(:occupied_by_same_color?).and_return(false)
        expect(subject.legal_move?(board, [4, 3], [4, 4])).to be(false)
      end
    end
    context 'is allowed to move to a spot with a black piece' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(rook)
        allow(board).to receive(:occupied_by_same_color?).and_return(false)
        expect(subject.legal_move?(board, [4, 3], [3, 5])).to be(true)
      end
    end
  end
  describe '.generate_possible_moves' do
    context 'when there are no possible moves' do
      before do
        allow(board).to receive(:valid_move?).with(subject, [0, 2], [1, 4]).and_return(false)
        allow(board).to receive(:valid_move?).with(subject, [0, 2], [1, 0]).and_return(false)
        allow(board).to receive(:valid_move?).with(subject, [0, 2], [2, 3]).and_return(false)
        allow(board).to receive(:valid_move?).with(subject, [0, 2], [2, 1]).and_return(false)
        allow(board).to receive(:valid_move?).with(subject, [0, 2], [4, 0]).and_return(false)
      end
      it 'returns an empty array' do
        expect(subject.generate_possible_moves(board, [0, 2])).to eq([])
      end
    end
    context 'when there are limited moves based on other pieces blocking' do
      before do
        allow(board).to receive(:valid_move?).with(subject, [0, 2], [1, 4]).and_return(false)
        allow(board).to receive(:valid_move?).with(subject, [0, 2], [1, 0]).and_return(false)
        allow(board).to receive(:valid_move?).with(subject, [0, 2], [2, 3]).and_return(true)
        allow(board).to receive(:valid_move?).with(subject, [0, 2], [2, 1]).and_return(true)
        allow(board).to receive(:valid_move?).with(subject, [0, 2], [4, 0]).and_return(false)
        allow(board).to receive(:valid_move?).with(subject, [0, 2], [4, 4]).and_return(false)
      end
      it 'returns an array with just those possibilities' do
        expect(subject.generate_possible_moves(board, [0, 2])).to eq([[2, 3], [2, 1]])
      end
    end
  end
end

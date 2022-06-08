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
        allow(board).to receive(:occupied_by_same_color?).and_return(false)
        expect(subject.legal_move?(board, [3, 3], [5, 4])).to be(false)
      end
    end
    context 'moves to the side' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        allow(board).to receive(:occupied_by_same_color?).and_return(false)
        expect(subject.legal_move?(board, [4, 3], [4, 7])).to be(true)
      end
    end
    context 'moves diagonally' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        allow(board).to receive(:occupied_by_same_color?).and_return(false)
        expect(subject.legal_move?(board, [4, 3], [7, 6])).to be(true)
      end
    end
  end

  describe '.generate_possible_moves' do
    context 'when there are possible moves in multiple directions' do
      before do
        allow(board).to receive(:valid_move?).and_return(true)
      end
      it 'returns an array with 21 possibilities from the bottom left corner on an empty board' do
        expect(subject.generate_possible_moves(board, [0, 0]).size).to eq(21)
      end
      it 'returns an array with 21 possibilities from the middle of an empty board' do
        expect(subject.generate_possible_moves(board, [3, 3]).size).to eq(27)
      end
      it 'returns an array with 27 possibilities from the top right corner on an empty board' do
        expect(subject.generate_possible_moves(board, [7, 7]).size).to eq(21)
      end
      it 'returns an array which includes all the orthogonal spots' do
        expect(subject.generate_possible_moves(board, [7, 7])).to eq([[7, 6], [7, 5], [7, 4], [7, 3], [7, 2], [7, 1], [7, 0], [6, 7], [5, 7], [4, 7], [3, 7], [2, 7], [1, 7], [0, 7], [6, 6], [5, 5], [4, 4], [3, 3], [2, 2], [1, 1], [0, 0]])
      end
    end
    context 'when there are no possible moves' do
      before do
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [1, 0]).and_return(false)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [0, 1]).and_return(false)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [1, 1]).and_return(false)
      end
      it 'returns an empty array' do
        expect(subject.generate_possible_moves(board, [0, 0])).to eq([])
      end
    end
    context 'when there are limited moves based on other pieces blocking' do
      before do
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [1, 0]).and_return(true)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [0, 1]).and_return(true)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [1, 1]).and_return(true)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [2, 0]).and_return(true)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [0, 2]).and_return(true)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [2, 2]).and_return(true)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [3, 0]).and_return(false)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [0, 3]).and_return(false)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [3, 3]).and_return(false)
      end
      it 'returns an array with just those possibilities' do
        expect(subject.generate_possible_moves(board, [0, 0])).to eq([[0, 1], [0, 2], [1, 0], [2, 0], [1, 1], [2, 2]])
      end
    end
  end
end

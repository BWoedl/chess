# frozen_string_literal: true

require 'piece'
require 'king'

describe King do
  subject(:king) { King.new('white') }
  let(:rook) { double('rook', color: 'white', move: 1) }
  let(:queen) { double('queen', color: 'white', move: 1) }
  let(:board) { double('board') }

  describe '.legal_move?' do
    context 'moves two spaces when not castling' do
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        allow(board).to receive(:occupied_by_same_color?).and_return(false)
        subject.instance_variable_set(:@move, 2)
        expect(subject.legal_move?(board, [3, 3], [5, 3])).to be(false)
      end
    end
    context 'moves one space to the side' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        allow(board).to receive(:occupied_by_same_color?).and_return(false)
        subject.instance_variable_set(:@move, 2)
        expect(subject.legal_move?(board, [4, 3], [4, 4])).to be(true)
      end
    end
    context 'moves one space diagonally' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        allow(board).to receive(:occupied_by_same_color?).and_return(false)
        subject.instance_variable_set(:@move, 2)
        expect(subject.legal_move?(board, [4, 3], [5, 4])).to be(true)
      end
    end
    context 'is a valid castling move' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(rook, nil)
        allow(board).to receive(:check?).and_return(false)
        allow(board).to receive(:occupied_by_same_color?).and_return(false)
        subject.instance_variable_set(:@move, 1)
        expect(subject.legal_move?(board, [0, 4], [0, 6])).to be(true)
      end
    end
  end

  describe '.castling_move?' do
    context 'rook has previously moved' do
      let(:rook) { double('rook', color: 'white', move: 3) }
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(rook)
        expect(subject.castling_move?(board, [0, 4], [0, 6])).to be false
      end
    end
    context 'king has previously moved' do
      it 'returns false' do
        subject.instance_variable_set(:@move, 3)
        allow(board).to receive(:get_piece).and_return(rook)
        expect(subject.castling_move?(board, [0, 4], [0, 6])).to be false
      end
    end
    context 'king is in check' do
      it 'returns false' do
        subject.instance_variable_set(:@move, 1)
        allow(board).to receive(:get_piece).and_return(rook)
        allow(board).to receive(:check?).and_return(true)
        expect(subject.castling_move?(board, [0, 4], [0, 6])).to be false
      end
    end
    context 'another piece is in the path' do
      it 'returns false' do
        subject.instance_variable_set(:@move, 1)
        allow(board).to receive(:get_piece).and_return(rook, queen)
        allow(board).to receive(:check?).and_return(false)
        expect(subject.castling_move?(board, [0, 4], [0, 6])).to be false
      end
    end
    context 'all criteria for a castling move is met' do
      it 'returns true' do
        subject.instance_variable_set(:@move, 1)
        allow(board).to receive(:get_piece).and_return(rook, nil)
        allow(board).to receive(:check?).and_return(false)
        expect(subject.castling_move?(board, [0, 4], [0, 6])).to be true
      end
    end
  end

  describe 'rook_spot_for_castling' do
    it 'returns the spot the white rook that will be castled is in' do
      expect(subject.rook_spot_for_castling([0, 4], [0, 6])).to eq([0, 7])
    end
    it 'returns the spot the black rook that will be castled is in' do
      expect(subject.rook_spot_for_castling([7, 4], [7, 2])).to eq([7, 0])
    end
  end

  describe '.generate_possible_moves' do
    context 'when there are no possible moves' do
      before do
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [0, 1]).and_return(false)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [1, 0]).and_return(false)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [1, 1]).and_return(false)
      end
      it 'returns an empty array' do
        expect(subject.generate_possible_moves(board, [0, 0])).to eq([])
      end
    end
    context 'when there are limited moves based on other pieces blocking' do
      before do
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [0, 1]).and_return(true)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [1, 0]).and_return(true)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [1, 1]).and_return(true)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [2, 2]).and_return(false)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [0, 2]).and_return(false)
        allow(board).to receive(:valid_move?).with(subject, [0, 0], [2, 0]).and_return(false)
      end
      it 'returns an array with just those possibilities' do
        expect(subject.generate_possible_moves(board, [0, 0])).to eq([[0, 1], [1, 0], [1, 1]])
      end
    end
  end
end

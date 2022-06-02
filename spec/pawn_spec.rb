# frozen_string_literal: true

require 'piece'
require 'pawn'

describe Pawn do
  let(:white_pawn) { Pawn.new('white') }
  let(:black_pawn) { Pawn.new('black') }
  let(:board) { double('board') }
  let(:king) { double('king', color: 'white') }

  describe '.legal_move? for black pawn' do
    context 'moves one space down the board' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(black_pawn.legal_move?(board, [4, 3], [3, 3])).to be(true)
      end
    end
    context 'moves two spaces on the first move' do
      it 'returns true' do
        black_pawn.instance_variable_set(:@move, 1)
        allow(board).to receive(:get_piece).and_return(nil)
        expect(black_pawn.legal_move?(board, [6, 3], [4, 3])).to be(true)
      end
    end
    context 'moves two spaces on a move besides the first' do
      it 'returns false' do
        black_pawn.instance_variable_set(:@move, 2)
        allow(board).to receive(:get_piece).and_return(nil)
        expect(black_pawn.legal_move?(board, [6, 3], [4, 3])).to be(false)
      end
    end
    context 'cannot move foward if spot is occupied' do
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(king)
        expect(black_pawn.legal_move?(board, [6, 3], [5, 3])).to be(false)
      end
    end
    context 'moves diagonally when no piece in the target spot' do
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(black_pawn.legal_move?(board, [5, 4], [4, 3])).to be(false)
      end
    end
    context 'moves diagonally when a piece in the target spot' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(white_pawn)
        expect(black_pawn.legal_move?(board, [5, 4], [4, 3])).to be(true)
      end
    end
    context 'moves diagonally more than one row' do
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(white_pawn)
        expect(black_pawn.legal_move?(board, [6, 5], [4, 3])).to be(false)
      end
    end
    context 'moves backward' do
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(black_pawn.legal_move?(board, [2, 3], [3, 3])).to be(false)
      end
    end
    context 'en passant is a valid move' do
      it 'returns true' do
        white_pawn.instance_variable_set(:@move, 2)
        allow(board).to receive(:get_piece).with([3, 3]).and_return(nil)
        allow(board).to receive(:get_piece).with([4, 3]).and_return(white_pawn)
        allow(board).to receive(:last_piece_moved).and_return(white_pawn)
        expect(black_pawn.legal_move?(board, [4, 4], [3, 3])).to be(true)
      end
    end
  end
  describe '.legal_move? for white pawn' do
    context 'moves down the board' do
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(white_pawn.legal_move?(board, [2, 4], [1, 4])).to be(false)
      end
    end
    context 'moves up the board' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(white_pawn.legal_move?(board, [2, 3], [3, 3])).to be(true)
      end
    end
    context 'en passant is a valid move' do
      it 'returns true' do
        black_pawn.instance_variable_set(:@move, 2)
        allow(board).to receive(:get_piece).with([5, 5]).and_return(nil)
        allow(board).to receive(:get_piece).with([4, 5]).and_return(black_pawn)
        allow(board).to receive(:last_piece_moved).and_return(black_pawn)
        expect(white_pawn.legal_move?(board, [4, 4], [5, 5])).to be(true)
      end
    end
  end
  describe '.en_passant?' do
    it 'returns false if there is no piece to pass' do
      allow(board).to receive(:get_piece).and_return(nil)
      expect(white_pawn.en_passant?(board, [4, 4], [5, 3])).to be false
    end
    it 'returns false if the piece to pass is not a pawn' do
      allow(board).to receive(:get_piece).and_return(king)
      expect(white_pawn.en_passant?(board, [4, 4], [5, 3])).to be false
    end
    it 'returns false if the piece to pass is a pawn that has not just made its first move 2 spaces' do
      black_pawn.instance_variable_set(:@move, 3)
      allow(board).to receive(:get_piece).and_return(black_pawn)
      expect(white_pawn.en_passant?(board, [4, 4], [5, 3])).to be false
    end
    it 'returns false if the piece to pass is a pawn that just made its first move 2 spaces but was not the last move on the board' do
      black_pawn.instance_variable_set(:@move, 2)
      allow(board).to receive(:last_piece_moved).and_return(king)
      allow(board).to receive(:get_piece).and_return(black_pawn)
      expect(white_pawn.en_passant?(board, [4, 4], [5, 3])).to be false
    end
    it 'returns true if the piece to pass is a pawn that just made its first move 2 spaces and was just the last move' do
      black_pawn.instance_variable_set(:@move, 2)
      allow(board).to receive(:get_piece).and_return(black_pawn)
      allow(board).to receive(:last_piece_moved).and_return(black_pawn)
      expect(white_pawn.en_passant?(board, [4, 4], [5, 3])).to be true
    end
  end
  describe '.en_passant_spot' do
    it 'returns the spot that has been passed to the left' do
      spot = [4, 3]
      expect(white_pawn.en_passant_spot([4, 4], [5, 3])).to eq(spot)
    end
    it 'returns the spot that has been passed to the left' do
      spot = [4, 5]
      expect(white_pawn.en_passant_spot([4, 4], [5,5])).to eq(spot)
    end
  end

  describe '.occupied?' do
    context 'if forward spot is filled with piece' do
<<<<<<< HEAD
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(black_pawn)
        expect(white_pawn.occupied?(board, [5, 3])).to be true
      end
    end
    context 'if forward spot is empty' do
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(white_pawn.occupied?(board, [5, 3])).to be false
>>>>>>> 9e732145508e98b94da461e32b892313ef461d9d
      end
    end
  end
end

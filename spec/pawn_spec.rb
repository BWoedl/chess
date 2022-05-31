# frozen_string_literal: true

require 'piece'
require 'pawn'

describe Pawn do
  let(:white_pawn) { Pawn.new('white') }
  let(:black_pawn) { Pawn.new('black') }
  let(:board) { double('board') }
  let(:king) { double('king') }

  describe '.legal_move? for black pawn' do
    context 'moves one space down the board' do
      xit 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(black_pawn.legal_move?(board, [4, 3], [3, 3])).to be(true)
      end
    end
    context 'moves two spaces on the first move' do
      xit 'returns true' do
        black_pawn.instance_variable_set(:@move, 1)
        allow(board).to receive(:get_piece).and_return(nil)
        expect(black_pawn.legal_move?(board, [6, 3], [4, 3])).to be(true)
      end
    end
    context 'moves two spaces on a move besides the first' do
      xit 'returns false' do
        black_pawn.instance_variable_set(:@move, 2)
        allow(board).to receive(:get_piece).and_return(nil)
        expect(black_pawn.legal_move?(board, [6, 3], [4, 3])).to be(false)
      end
    end
    context 'moves diagonally when no piece in the target spot' do
      xit 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(black_pawn.legal_move?(board, [5, 4], [4, 3])).to be(false)
      end
    end
    context 'moves diagonally when a piece in the target spot' do
      xit 'returns true' do
        allow(board).to receive(:get_piece).and_return(white_pawn)
        expect(black_pawn.legal_move?(board, [5, 4], [4, 3])).to be(true)
      end
    end
    context 'moves diagonally more than one row' do
      xit 'returns false' do
        allow(board).to receive(:get_piece).and_return(white_pawn)
        expect(black_pawn.legal_move?(board, [6, 5], [4, 3])).to be(false)
      end
    end
    context 'moves backward' do
      xit 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(black_pawn.legal_move?(board, [2, 3], [3, 3])).to be(false)
      end
    end
    context 'en passant is a valid move' do
      it 'returns true' do
        allow(board).to receive(:get_piece).with([3, 3]).and_return(nil)
        allow(board).to receive(:get_piece).with([4, 3]).and_return(white_pawn)
        expect(black_pawn.legal_move?(board, [4, 4], [3, 3])).to be(true)
      end
    end
  end
  describe '.legal_move? for white pawn' do
    context 'moves down the board' do
      xit 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(white_pawn.legal_move?(board, [2, 4], [1, 4])).to be(false)
      end
    end
    context 'moves up the board' do
      xit 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(white_pawn.legal_move?(board, [2, 3], [3, 3])).to be(true)
      end
    end
    context 'en passant is a valid move' do
      it 'returns true' do
        allow(board).to receive(:get_piece).with([5, 5]).and_return(nil)
        allow(board).to receive(:get_piece).with([4, 5]).and_return(black_pawn)
        expect(white_pawn.legal_move?(board, [4, 4], [5, 5])).to be(true)
      end
    end
  end
  describe '.en_passant?' do
    xit 'returns false if there is no piece to pass' do
      allow(board).to receive(:get_piece).and_return(nil)
      expect(white_pawn.en_passant?(board, [4, 4], [5, 3])).to be false
    end
    xit 'returns false if the piece to pass is not a pawn' do
      allow(board).to receive(:get_piece).and_return(king)
      expect(white_pawn.en_passant?(board, [4, 4], [5, 3])).to be false
    end
    xit 'returns false if the piece to pass is a pawn that has not just made its first move 2 spaces' do
      black_pawn.instance_variable_set(:@move, 3)
      allow(board).to receive(:get_piece).and_return(black_pawn)
      expect(white_pawn.en_passant?(board, [4, 4], [5, 3])).to be false
    end
    xit 'returns true if the piece to pass is a pawn that just made its first move 2 spaces' do
      black_pawn.instance_variable_set(:@move, 2)
      allow(board).to receive(:get_piece).and_return(black_pawn)
      expect(white_pawn.en_passant?(board, [4, 4], [5, 3])).to be true
    end
  end
  describe '.en_passant_spot' do
    xit 'returns the spot that has been passed to the left' do
      spot = [4, 3]
      expect(white_pawn.en_passant_spot([4, 4], [5, 3])).to eq(spot)
    end
    xit 'returns the spot that has been passed to the left' do
      spot = [4, 5]
      expect(white_pawn.en_passant_spot([4, 4], [5,5])).to eq(spot)
    end
  end
end

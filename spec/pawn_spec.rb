# frozen_string_literal: true

require 'piece'
require 'pawn'

describe Pawn do
  let(:white_pawn) { Pawn.new('white') }
  let(:black_pawn) { Pawn.new('black') }
  let(:board) { double('board') }

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
    context 'moves diagonally when no piece in the target spot' do
      it 'returns false' do
        #target spot empty
        allow(board).to receive(:get_piece).and_return(nil)
        expect(black_pawn.legal_move?(board, [5, 4], [4, 3])).to be(false)
      end
    end
    xcontext 'moves diagonally when a piece in the target spot' do
      it 'returns true' do
        # target spot occupied
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
  end
end

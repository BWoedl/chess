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
      xit 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(black_pawn.legal_move?(board, [2, 3], [3, 3])).to be(false)
      end
    end
    context 'en passant is not valid because passed piece is king' do
      xit 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(black_pawn.legal_move?(board, [2, 3], [3, 3])).to be(false)
      end
    end
    context 'en passant is not valid because passed piece was first move' do
      xit 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(black_pawn.legal_move?(board, [2, 3], [3, 3])).to be(false)
      end
    end
    context 'en passant is not valid because passed piece was third move' do
      xit 'returns false' do
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
  describe '.en_passant' do 
    xit 'updates the status of the piece it passes' do 
    end
    xit 'updates the spot that it passed the piece on to be nil' do 
    end
  end
end

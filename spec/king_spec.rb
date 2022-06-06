# frozen_string_literal: true

require 'piece'
require 'king'

describe King do
  subject(:king) { King.new('white') }
  let(:rook) { double('rook', color: 'white') }
  let(:board) { double('board') }

  describe '.legal_move' do
    context 'moves two spaces' do
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(subject.legal_move?(board, [3, 3], [5, 3])).to be(false)
      end
    end
    context 'moves one space to the side' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(subject.legal_move?(board, [4, 3], [4, 4])).to be(true)
      end
    end
    context 'moves one space diagonally' do
      it 'returns true' do
        allow(board).to receive(:get_piece).and_return(nil)
        expect(subject.legal_move?(board, [4, 3], [5, 4])).to be(true)
      end
    end
    context 'cannot move into a space occupied by same color' do
      it 'returns false' do
        allow(board).to receive(:get_piece).and_return(rook)
        expect(subject.legal_move?(board, [4, 3], [4, 4])).to be(false)
      end
    end
    context 'is a valid castling move' do
      xit 'returns true' do
      end
    end
  end

  describe '.castling_move?' do
    context '...' do
      xit '...' do
      end
    end
  end

  describe 'rook_spot_for_castling' do
    xit 'returns the spot the rook that will be castled is in' do
    end
  end
end

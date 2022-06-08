require 'piece'

describe Piece do
  subject(:piece) { described_class.new('white') }
  let(:board) { double('board') }
  let(:king) { double('king', color: 'white') }
  let(:queen) { double('queen', color: 'black') }

  describe 'diagonal_move?' do
    it 'returns true when diagonal' do
      expect(subject.diagonal_move?([0, 0], [6, 6])).to be true
    end
    it 'returns false when move is straight' do
      expect(subject.diagonal_move?([0, 0], [4, 0])).to be false
    end
  end

  describe '.generate_path' do
    context 'with a diagonal route' do
      it 'returns an array of a diagonal spots' do
        path = [[3, 3], [4, 4], [5, 5], [6, 6]]
        expect(subject.generate_path([2, 2], [7, 7], 1, 1)).to eq(path)
      end
    end
    context 'with a horizontal route' do
      it 'returns an array of a horizontal spots' do
        path = [[2, 3], [2, 4], [2, 5], [2, 6]]
        expect(subject.generate_path([2, 2], [2, 7], 0, 1)).to eq(path)
      end
    end
    context 'with a vertical route' do
      it 'returns an array of a vertical spots' do
        path = [[3, 2], [4, 2], [5, 2], [6, 2]]
        expect(subject.generate_path([2, 2], [7, 2], 1, 0)).to eq(path)
      end
    end
  end

  describe '.intermediate_spots_open?' do
    context 'a spot is filled with a piece of the same color' do
      it 'returns false' do 
        path = [[3, 2], [4, 2], [5, 2], [6, 2]]
        allow(board).to receive(:get_piece).and_return(nil, nil, king, nil)
        expect(subject.intermediate_spots_open?(board, path)).to be false
      end
    end
    context 'a spot is filled with a piece of a different color' do
      it 'returns false' do 
        path = [[3, 2], [4, 2], [5, 2], [6, 2]]
        allow(board).to receive(:get_piece).and_return(nil, queen, nil, nil)
        expect(subject.intermediate_spots_open?(board, path)).to be false
      end
    end
    context 'all spots are empty' do
      it 'returns true' do 
        path = [[3, 2], [4, 2], [5, 2], [6, 2]]
        allow(board).to receive(:get_piece).and_return(nil, nil, nil, nil)
        expect(subject.intermediate_spots_open?(board, path)).to be true
      end
    end
  end

  describe '.get_direction' do
    context 'end row is greater than start row' do
      it 'returns 1 in the first spot' do
        operators = [1, 1]
        expect(subject.get_direction([2, 3], [6, 7])).to eq(operators)  
      end
    end
    context 'start row is greater than end row' do
      it 'returns -1 in the first spot' do
        operators = [-1, 1]
        expect(subject.get_direction([6, 3], [2, 7])).to eq(operators)  
      end
    end
    context 'end column is greater than start column' do
      it 'returns 1 in the second spot' do
        operators = [1, 1]
        expect(subject.get_direction([2, 3], [6, 7])).to eq(operators)
      end
    end
    context 'start column is greater than end column' do
      it 'returns -1 in the second spot' do
        operators = [1, -1]
        expect(subject.get_direction([2, 7], [6, 3])).to eq(operators)   
      end
    end
  end
  describe '.generate_possible_moves' do
    context 'when there are possible moves in multiple directions' do
      before do
        allow(board).to receive(:valid_move?).and_return(true)
      end
      it 'returns an array with 14 possibilities from the bottom left corner on an empty board' do
        expect(subject.generate_possible_moves(board, [0, 0]).size).to eq(14)
      end
      it 'returns an array with 14 possibilities from the middle of an empty board' do
        expect(subject.generate_possible_moves(board, [3, 3]).size).to eq(14)
      end
      it 'returns an array with 14 possibilities from the top right corner on an empty board' do
        expect(subject.generate_possible_moves(board, [7, 7]).size).to eq(14)
      end
      it 'returns an array which includes all the orthogonal spots' do
        expect(subject.generate_possible_moves(board, [7, 7])).to eq([[6, 7], [5, 7], [4, 7], [3, 7], [2, 7], [1, 7], [0, 7], [7, 6], [7, 5], [7, 4], [7, 3], [7, 2], [7, 1], [7, 0]])
      end
    end
    context 'when there are no possible moves' do
      before do
        allow(board).to receive(:valid_move?).with(rook, [0, 0], [1, 0]).and_return(false)
        allow(board).to receive(:valid_move?).with(rook, [0, 0], [0, 1]).and_return(false)
      end
      it 'returns an empty array' do
        expect(subject.generate_possible_moves(board, [0, 0])).to eq([])
      end
    end
    context 'when there are limited moves based on other pieces blocking' do
      before do
        allow(board).to receive(:valid_move?).with(rook, [0, 0], [1, 0]).and_return(true)
        allow(board).to receive(:valid_move?).with(rook, [0, 0], [0, 1]).and_return(true)
        allow(board).to receive(:valid_move?).with(rook, [0, 0], [2, 0]).and_return(true)
        allow(board).to receive(:valid_move?).with(rook, [0, 0], [0, 2]).and_return(true)
        allow(board).to receive(:valid_move?).with(rook, [0, 0], [3, 0]).and_return(false)
        allow(board).to receive(:valid_move?).with(rook, [0, 0], [0, 3]).and_return(false)
      end
      it 'returns an array with just those possibilities' do
        expect(subject.generate_possible_moves(board, [0, 0])).to eq([[1, 0], [2, 0], [0, 1], [0, 2]])
      end
    end
  end
end

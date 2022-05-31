require 'piece'

describe Piece do 
  subject(:piece) { described_class.new('white') }
  let(:board) { double('board') }
  let(:king) { double('king', color: 'white') }
  let(:queen) { double('queen', color: 'black') }

  describe '.occupied_by_same_color?' do 
    context 'when target space is occupied by the same color piece' do 
      it 'returns true' do 
        allow(board).to receive(:get_piece).with([1, 1]).and_return(king)
        expect(subject.occupied_by_same_color?(board, [1, 1])).to be true
      end
    end
    context 'when target space is occupied by a piece of the opposite color' do 
      it 'returns false' do 
        allow(board).to receive(:get_piece).with([2, 2]).and_return(queen)
        expect(subject.occupied_by_same_color?(board, [2, 2])).to be false
      end
    end
  end

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
end

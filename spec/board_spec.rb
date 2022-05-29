# frozen_string_literal: true

require 'board'
require 'spot'

describe Board do
  subject(:board) { Board.new }

  describe '.create_board' do
    context 'resets the board to an empty 8x8 grid' do
      it 'contains an 8x8 nested array' do
        grid = subject.instance_variable_get(:@grid)
        expect(grid.length).to eq(8) and expect(grid.all? { |row| row.length == 8 }).to be true
      end
      it 'fills the array with Spots' do
        grid = subject.instance_variable_get(:@grid)
        expect(grid[0][0]).to be_a(Spot)
      end
      it 'sets middle spots to have nil pieces' do
        grid = subject.instance_variable_get(:@grid)
        expect(grid[2][0].piece).to be nil
      end
    end
  end

  describe 'setup_board_pieces' do
    context 'adds pieces to spots on board' do
      it 'adds pawns to 2nd row' do
        grid = subject.instance_variable_get(:@grid)
        expect(grid[1][6].piece).to be_a(Pawn)
      end
      it 'adds queen to the fifth column on each side' do 
        grid = subject.instance_variable_get(:@grid)
        expect(grid[0][4].piece).to be_a(Queen)
      end
      it 'adds king to the fourth column on each side' do 
        grid = subject.instance_variable_get(:@grid)
        expect(grid[7][3].piece).to be_a(King)
      end
    end
  end
end

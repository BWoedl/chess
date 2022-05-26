require_relative '../lib/board'
require_relative '../lib/spot'

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

  describe '.start_board' do
    context 'adds pieces to spots on board' do
      it 'adds pawns to 2nd row' do
      grid = subject.instance_variable_get(:@grid)
      expect(grid[1][6].piece).to be_a(Pawn)
      end
    end
  end
end

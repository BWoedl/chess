# frozen_string_literal: true

require 'board'
require 'spot'

describe Board do
  subject(:board) { Board.new }
  let(:white_king) { double('king', class: King, color: 'white') }
  let(:white_rook) { double('rook', class: Rook, color: 'white') }
  let(:white_queen) { double('queen', class: Queen, color: 'white') }
  let(:white_knight) { double('knight', class: Knight, color: 'white') }
  let(:white_bishop) { double('bishop', class: Bishop, color: 'white') }
  let(:white_pawn) { double('pawn', class: Pawn, color: 'white') }
  let(:black_rook) { double('rook', class: Rook, color: 'black') }
  let(:black_king) { double('king', class: King, color: 'black') }
  let(:spot) { double('spot', piece: nil) }
  let(:k_spot_b) { double('spot', piece: black_king) }
  let(:r_spot_b) { double('spot', piece: black_rook) }
  let(:k_spot_w) { double('spot', piece: white_king) }
  let(:r_spot_w) { double('spot', piece: white_rook) }
  let(:q_spot_w) { double('spot', piece: white_queen) }
  let(:n_spot_w) { double('spot', piece: white_knight) }
  let(:b_spot_w) { double('spot', piece: white_bishop) }
  let(:p_spot_w) { double('spot', piece: white_pawn) }

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
      it 'adds king to the fifth column on each side' do
        grid = subject.instance_variable_get(:@grid)
        expect(grid[0][4].piece).to be_a(King)
      end
      it 'adds queen to the fourth column on each side' do
        grid = subject.instance_variable_get(:@grid)
        expect(grid[7][3].piece).to be_a(Queen)
      end
    end
  end

  describe '.get_piece' do
    context 'when a king is in the spot on the board' do
      it 'returns king class' do
        subject.instance_variable_set(:@grid, [[r_spot_b, spot, spot, spot, k_spot_b, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot]])
        expect(subject.get_piece([0, 4])).to match(black_king)
      end
    end

    context 'when a rook is in the spot on the board ' do
      it 'returns rook class' do
        subject.instance_variable_set(:@grid, [[r_spot_b, spot, spot, spot, k_spot_b, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot]])
        expect(subject.get_piece([0, 0])).to match(black_rook)
      end
    end
  end

  describe 'active_piece_spots' do
    context 'when the board has just been setup and white is specified as an argument' do
      it 'returns all 16 spots with white pieces' do
        subject.instance_variable_set(:@grid, [[spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [p_spot_w, p_spot_w, p_spot_w, p_spot_w, p_spot_w, p_spot_w, p_spot_w, p_spot_w],
                                               [r_spot_w, n_spot_w, b_spot_w, q_spot_w, k_spot_w, b_spot_w, n_spot_w, r_spot_w]])
        expect(subject.active_opponent_spots('black').count).to eq(16)
      end
    end
    context 'when the white rooks have been defeated' do
      it 'does not return any spots with those pieces' do
        subject.instance_variable_set(:@grid, [[spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [p_spot_w, p_spot_w, p_spot_w, p_spot_w, p_spot_w, p_spot_w, p_spot_w, p_spot_w],
                                               [spot, n_spot_w, b_spot_w, q_spot_w, k_spot_w, b_spot_w, n_spot_w, spot]])
        expect(subject.active_opponent_spots('black')).not_to include(r_spot_w)
      end
    end
    context 'when black is specified as an argument' do
      it 'does not return any spots with white pieces' do
        subject.instance_variable_set(:@grid, [[spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [p_spot_w, p_spot_w, p_spot_w, p_spot_w, p_spot_w, p_spot_w, p_spot_w, p_spot_w],
                                               [r_spot_w, n_spot_w, b_spot_w, q_spot_w, k_spot_w, b_spot_w, n_spot_w, r_spot_w]])
        expect(subject.active_opponent_spots('white').count).to eq(0)
      end
    end
  end

  describe 'find_opponent_king_spot' do
    context 'it returns the spot with the king in it' do
      it 'returns the spot that has the king piece with the specified color' do
        subject.instance_variable_set(:@grid, [[spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [p_spot_w, p_spot_w, p_spot_w, p_spot_w, p_spot_w, p_spot_w, p_spot_w, p_spot_w],
                                               [r_spot_w, n_spot_w, b_spot_w, q_spot_w, k_spot_w, b_spot_w, n_spot_w, r_spot_w]])
        allow(k_spot_w.piece).to receive(:instance_of?).with(King).and_return true
        expect(subject.find_king_spot('white')).to eq(k_spot_w)
      end
    end
  end

  describe '.check?' do
    context 'when a rook has a legal move which would capture the king' do
      before do
        subject.instance_variable_set(:@grid, [[spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, r_spot_b, spot, spot, spot],
                                               [p_spot_w, p_spot_w, p_spot_w, p_spot_w, spot, p_spot_w, p_spot_w, p_spot_w],
                                               [r_spot_w, n_spot_w, b_spot_w, q_spot_w, k_spot_w, b_spot_w, n_spot_w, r_spot_w]])
        allow(k_spot_w.piece).to receive(:instance_of?).with(King).and_return true
        allow(r_spot_b).to receive(:x).and_return(5)
        allow(r_spot_b).to receive(:y).and_return(4)
        allow(k_spot_w).to receive(:x).and_return(7)
        allow(k_spot_w).to receive(:y).and_return(4)
        allow(black_rook).to receive(:legal_move?).and_return true
      end
      it 'returns true' do
        expect(subject.check?('white')).to be true
      end
    end
    context 'when there are no legal moves which could capture the king' do
      before do
        subject.instance_variable_set(:@grid, [[spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, spot, spot, spot, spot],
                                               [spot, spot, spot, spot, r_spot_b, spot, spot, spot],
                                               [spot, spot, spot, spot, p_spot_w, spot, spot, spot],
                                               [p_spot_w, p_spot_w, spot, p_spot_w, spot, p_spot_w, p_spot_w, p_spot_w],
                                               [r_spot_w, n_spot_w, b_spot_w, q_spot_w, k_spot_w, b_spot_w, n_spot_w, r_spot_w]])
        allow(k_spot_w.piece).to receive(:instance_of?).with(King).and_return true
        allow(r_spot_b).to receive(:x).and_return(4)
        allow(r_spot_b).to receive(:y).and_return(4)
        allow(k_spot_w).to receive(:x).and_return(7)
        allow(k_spot_w).to receive(:y).and_return(4)
        allow(black_rook).to receive(:legal_move?).and_return false
      end
      it 'returns false' do
        expect(subject.check?('white')).to be false
      end
    end
  end
end

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
  let(:black_pawn) { double('pawn', class: Pawn, color: 'black') }
  let(:black_rook) { double('rook', class: Rook, color: 'black') }
  let(:black_king) { double('king', class: King, color: 'black') }
  let(:spot) { double('spot', piece: nil) }
  let(:k_spot_b) { double('spot1', piece: black_king) }
  let(:r_spot_b) { double('spot2', piece: black_rook) }
  let(:k_spot_w) { double('spot3', piece: white_king) }
  let(:r_spot_w) { double('spot4', piece: white_rook) }
  let(:q_spot_w) { double('spot5', piece: white_queen) }
  let(:n_spot_w) { double('spot6', piece: white_knight) }
  let(:b_spot_w) { double('spot7', piece: white_bishop) }
  let(:p_spot_w) { double('spot8', piece: white_pawn) }
  let(:p_spot_b) { double('spot9', piece: black_pawn) }
  let(:e_spot) { double('spot0') }

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
  describe '.occupied_by_same_color?' do
    context 'when target space is occupied by the same color piece' do
      it 'returns true' do
        allow(subject).to receive(:get_piece).with([1, 1]).and_return(white_rook)
        expect(subject.occupied_by_same_color?(white_queen, [1, 1])).to be true
      end
    end
    context 'when target space is occupied by a piece of the opposite color' do
      it 'returns false' do
        allow(subject).to receive(:get_piece).with([2, 2]).and_return(black_rook)
        expect(subject.occupied_by_same_color?(white_queen, [2, 2])).to be false
      end
    end
  end

  describe '.clone board' do
    before do
      allow(subject).to receive(:active_opponent_spots).and_return([p_spot_w])
      allow(p_spot_w).to receive(:x).and_return(7)
      allow(p_spot_w).to receive(:y).and_return(2)
    end
    it 'returns a new board' do
      expect(subject.clone_board).to be_instance_of(Board)
    end
    it 'includes pieces in the same spots as the cloned board' do
      test_board = subject.clone_board
      test_board.get_piece([7, 2])
      expect(test_board.get_piece([7, 2])).to be_instance_of(Pawn)
    end
  end

  describe '.puts king in check' do
    context 'after the test board is updated, there are no legal moves to put the king in check' do
      before do
        allow(subject).to receive(:active_opponent_spots).and_return([p_spot_w])
        allow(p_spot_w).to receive(:x).and_return(7)
        allow(p_spot_w).to receive(:y).and_return(2)
      end
      it 'returns false' do
        expect(subject.puts_king_in_check?([7, 2], [4, 4])).to be false
      end
    end
    context 'after the test board is updated, there is a legal move to put the king in check' do
      before do
        allow(subject).to receive(:active_opponent_spots).and_return([p_spot_w, q_spot_w, p_spot_b, k_spot_w])
        allow(p_spot_w).to receive(:x).and_return(4)
        allow(p_spot_w).to receive(:y).and_return(2)
        allow(q_spot_w).to receive(:x).and_return(7)
        allow(q_spot_w).to receive(:y).and_return(4)
        allow(p_spot_b).to receive(:x).and_return(5)
        allow(p_spot_b).to receive(:y).and_return(5)
        allow(k_spot_w).to receive(:x).and_return(6)
        allow(k_spot_w).to receive(:y).and_return(4)
        allow(white_queen).to receive(:legal_move?).and_return(true)
      end
      it 'returns true' do
        start_spot = [4, 2]
        end_spot = [4, 4]
        expect(subject.puts_king_in_check?(start_spot, end_spot)).to be true
      end
    end
  end

  describe '.update' do
    context 'when piece is not a pawn' do
      it 'passant_spot remains as nil' do
        expect(subject).to receive(:move_piece).with(white_king, [0, 0], [0, 1], nil)
        subject.update(white_king, [0, 0], [0, 1], nil)
      end
    end
    context 'when piece is a pawn' do
      before do
        allow(white_pawn).to receive(:instance_of?).and_return(true)
        allow(white_pawn).to receive(:instance_of?).with(King).and_return(false)
      end
      it 'assigns passant_spot if it is a valid passing move' do
        allow(white_pawn).to receive(:en_passant?).and_return([4, 5])
        allow(white_pawn).to receive(:en_passant_spot).and_return([4, 5])
        subject.update(white_pawn, [4, 4], [5, 5], nil)
      end
      it 'does not assign passant_spot if it is an invalid passing move' do
        allow(white_pawn).to receive(:en_passant?).and_return(false)
        subject.update(white_pawn, [4, 4], [5, 5], nil)
      end
    end
    context 'when it is a castling move' do
      before do
        allow(white_king).to receive(:move=)
        allow(white_king).to receive(:instance_of?).and_return(false, true)
        allow(white_king).to receive(:castling_move?).and_return(true)
      end
      it 'calls the move_rook_for_castling method' do
        expect(subject).to receive(:move_rook_for_castling)
        subject.update(white_king, [0, 4], [0, 6], nil)
      end
    end
  end

  describe '.move_piece' do
    context 'when there is no piece in the target spot' do
      before do
        subject.instance_variable_set(:@grid, [[e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                               [e_spot, k_spot_w, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                               [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                               [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                               [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                               [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                               [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                               [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot]])
        allow(k_spot_w).to receive(:piece=)
        allow(e_spot).to receive(:piece=)
        allow(e_spot).to receive(:piece).and_return(nil)
      end
      it 'does not call the defeat_piece method' do
        subject.move_piece(white_king, [1, 1], [2, 2])
        expect(subject).not_to receive(:defeat_piece)
      end
    end
    context 'when there is a piece in the target spot' do
      before do
        subject.instance_variable_set(:@grid, [[e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                               [e_spot, k_spot_b  , e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                               [e_spot, e_spot, q_spot_w, e_spot, e_spot, e_spot, e_spot, e_spot],
                                               [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                               [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                               [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                               [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                               [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot]])
        allow(white_queen).to receive(:defeated=)
        allow(q_spot_w).to receive(:piece=)
        allow(k_spot_b).to receive(:piece=)
      end
      it 'calls the defeat_piece method' do
        expect(subject).to receive(:defeat_piece)
        subject.move_piece(black_king, [1, 1], [2, 2])
      end
      it 'sets start spot as nil' do
        expect(k_spot_b).to receive(:piece=).with(nil)
        subject.move_piece(black_king, [1, 1], [2, 2])
      end
    end
  end

  describe 'defeat_piece' do
    it 'it changes the defeated attribute on a direct capture' do
      target_spot_piece = white_queen
      expect(target_spot_piece).to receive(:defeated=)
      subject.defeat_piece(white_queen, nil)
    end
    it 'it changes the defeated attribute on an en passant move' do
      target_spot_piece = white_queen
      expect(target_spot_piece).to receive(:defeated=)
      subject.defeat_piece(white_queen, nil)
    end
  end

  describe '.move_rook_for_castling' do
    before do
      subject.instance_variable_set(:@grid, [[e_spot, e_spot, e_spot, e_spot, k_spot_b, e_spot, e_spot, r_spot_b],
                                             [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                             [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                             [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                             [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                             [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                             [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                             [r_spot_w, e_spot, e_spot, e_spot, k_spot_w, e_spot, e_spot, e_spot]])
      allow(e_spot).to receive(:piece=)
    end
    context 'moves a white rook on the left side' do
      it 'calls for the rook to be moved to the left of the king' do
        allow(white_king).to receive(:rook_spot_for_castling).and_return([0, 0])
      allow(e_spot).to receive(:piece).and_return(white_rook)
        expect(subject).to receive(:move_piece).with(white_rook, [0, 0], [0, 3])
        subject.move_rook_for_castling(white_king, [0, 4], [0, 2])
      end
    end
    context 'moves a black rook on the right side' do
      it 'calls for the rook to be moved to the right of the king' do
        allow(black_king).to receive(:rook_spot_for_castling).and_return([7, 7])
      allow(e_spot).to receive(:piece).and_return(black_rook)
        expect(subject).to receive(:move_piece).with(black_rook, [7, 7], [7, 5])
        subject.move_rook_for_castling(black_king, [7, 4], [7, 6])
      end
    end
  end

  describe '.valid_move?' do
    context 'checks if a player tries remain in the same space' do
      before do
        allow(subject).to receive(:active_opponent_spots).and_return([p_spot_w])
        allow(p_spot_w).to receive(:x).and_return(2)
        allow(p_spot_w).to receive(:y).and_return(3)
        allow(subject).to receive(:puts_king_in_check?).and_return(false)
      end
      it 'returns true if spots are different' do
        allow(white_king).to receive(:legal_move?).with(board, [2, 3], [2, 5]).and_return(true)
        expect(subject.valid_move?(white_king, [2, 3], [2, 5])).to be true
      end
      it 'returns false if spots are the same' do
        allow(white_king).to receive(:legal_move?).with(board, [3, 4], [3, 4]).and_return(true)
        expect(subject.valid_move?(white_king, [3, 4], [3, 4])). to be false
      end
      xit 'does additional checks?' do
      end
    end
  end

  describe '.occupied?' do
    context 'if forward spot is filled with piece' do
      it 'returns true' do
        allow(subject).to receive(:get_piece).and_return(black_pawn)
        expect(subject.occupied?([5, 3])).to be true
      end
    end
    context 'if forward spot is empty' do
      it 'returns false' do
        allow(subject).to receive(:get_piece).and_return(nil)
        expect(subject.occupied?([5, 3])).to be false
      end
    end
  end
end

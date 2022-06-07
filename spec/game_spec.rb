# frozen_string_literal: true

require 'game'

describe Game do
  let(:board) { double('board') }
  let(:white_king) { double('king', class: King, color: 'white', move: 1, defeated: false) }
  let(:black_king) { double('king', class: King, color: 'black', move: 1, defeated: false) }
  let(:queen) { double('queen', class: Queen, color: 'black', move: 1, defeated: false) }
  let(:white_pawn) { double('pawn', class: Pawn, color: 'white', move: 1, defeated: false) }
  let(:black_pawn) { double('pawn', class: Pawn, color: 'black', move: 1, defeated: false) }
  let(:white_rook) { double('rook', class: Rook, color: 'white', move: 1, defeated: false) }
  let(:black_rook) { double('rook', class: Rook, color: 'black', move: 1, defeated: false) }
  let(:p_spot_w) { double('spot1', piece: white_pawn) }
  let(:p_spot_b) { double('spot1', piece: black_pawn) }
  let(:e_spot) { double('spot') }
  let(:k_spot) { double('spot', piece: white_king) }
  let(:k_spot_b) { double('spot', piece: black_king) }  
  let(:r_spot_w) { double('spot', piece: white_rook) }
  let(:r_spot_b) { double('spot', piece: black_rook) }
  let(:q_spot) { double('spot', piece: queen) }
  let(:player1) { double('player', name: 'Dingo', color: 'white') }
  let(:player2) { double('player', name: 'Huckleberry', color: 'black') }
  subject(:game) { described_class.new(player1, player2, board) }

  context 'initializer' do
    it 'gets created' do
      expect(subject).to be_a(Game)
    end
  end

  describe '.valid_input?' do
    context 'input doesn\'t include 2 characters' do
      it 'returns false' do
        input = 'a'
        expect(subject.valid_input?(input)).to be false
      end
    end

    context 'input is 0 characters' do
      it 'returns false' do
        input = ''
        expect(subject.valid_input?(input)).to be false
      end
    end

    context 'input includes a number out of range' do
      it 'returns false' do
        input = 'a9'
        expect(game.valid_input?(input)).to be false
      end
    end

    context 'input includes a letter out of range' do
      it 'returns false' do
        input = 'j3'
        expect(subject.valid_input?(input)).to be false
      end
    end

    context 'input is valid' do
      it 'returns true' do
        input = 'a1'
        expect(subject.valid_input?(input)).to be true
      end
    end
  end

  describe '.convert_input' do
    it 'returns an array with row and column number' do
      input = 'b4'
      expect(subject.convert_input(input)).to eq([3, 1])
    end
  end

  describe '.valid_turn?' do
    context 'checks if a player tries remain in the same space' do
      before do
        allow(board).to receive(:active_opponent_spots).and_return([p_spot_w])
        allow(p_spot_w).to receive(:x).and_return(2)
        allow(p_spot_w).to receive(:y).and_return(3)
      end
      it 'returns true if spots are different' do
        allow(white_king).to receive(:legal_move?).with(board, [2, 3], [2, 5]).and_return(true)
        expect(subject.valid_turn?(white_king, [2, 3], [2, 5])).to be true
      end
      it 'returns false if spots are the same' do
        allow(white_king).to receive(:legal_move?).with(board, [3, 4], [3, 4]).and_return(true)
        expect(subject.valid_turn?(white_king, [3, 4], [3, 4])). to be false
      end
    end
  end

  describe '.spot_to_move' do
    it 'returns an array with row and column number' do
      allow(subject).to receive(:puts)
      allow(subject).to receive(:gets).and_return('a4')
      expect(subject.spot_to_move).to eq('a4')
    end
  end

  describe '.piece_to_move' do
    it 'returns an array with row and column number' do
      allow(subject).to receive(:puts)
      allow(subject).to receive(:gets).and_return('b4')
      allow(board).to receive(:get_piece).and_return(white_king)
      expect(subject.piece_to_move).to eq('b4')
    end
  end

  describe '.player_turn' do
    context 'specifies the player whose turn it is' do
      it 'returns player1 if odd turn' do
        subject.instance_variable_set(:@turn, 1)
        expect(subject.player_turn).to eq(player1)
      end

      it 'returns player2 if odd turn' do
        subject.instance_variable_set(:@turn, 6)
        expect(subject.player_turn).to eq(player2)
      end
    end
  end

  describe '.play' do
    context 'when game in progress' do
      before do
        allow(subject).to receive(:game_over?).and_return(false, true)
        allow(subject).to receive(:gets).and_return('a2', 'a3')
        allow(board).to receive(:get_piece).and_return(white_king)
        allow(white_king).to receive(:legal_move?).with(0, 1).and_return(true)
        allow(subject).to receive(:puts)
        allow(board).to receive(:display)
      end
      it 'calls for another turn' do
        expect(subject).to receive(:take_turn).once
        subject.play
      end
    end
  end

  describe '.take_turn' do
    context 'when turn is not valid' do
      before do
        allow(subject).to receive(:gets).and_return('c8', 'e8')
        allow(board).to receive(:grid)
        allow(board).to receive(:get_piece).and_return(white_king, white_king)
        allow(white_king).to receive(:valid_turn?).and_return(false)
        allow(white_king).to receive(:legal_move?).and_return(false)
        allow(subject).to receive(:puts)
      end
      it 'does not update the board' do
        expect(subject).not_to receive(:update_board)
        subject.take_turn
      end
    end
    context 'when turn is valid' do
      before do
        allow(subject).to receive(:gets).and_return('c8', 'd8')
        allow(board).to receive(:grid)
        allow(board).to receive(:get_piece).and_return(white_king, white_king)
        allow(white_king).to receive(:valid_turn?).and_return(true)
        allow(white_king).to receive(:legal_move?).and_return(true)
        allow(subject).to receive(:puts)
        subject.instance_variable_set(:@turn, 1)
        allow(board).to receive(:active_opponent_spots).and_return([p_spot_w])
        allow(p_spot_w).to receive(:x).and_return(7)
        allow(p_spot_w).to receive(:y).and_return(2)
        allow(white_king).to receive(:move=)
        allow(board).to receive(:last_piece_moved=)
        allow(white_king).to receive(:defeated=)
        allow(board).to receive(:display)
      end
      it 'calls to update the board' do
        expect(subject).to receive(:update_board).twice
        subject.take_turn
      end
    end
  end

  describe '.update_board' do
    context 'when piece is not a pawn' do
      before do
        allow(subject).to receive(:move_piece)
        allow(board).to receive(:display)
        allow(white_king).to receive(:move=)
        allow(board).to receive(:last_piece_moved=)
      end
      it 'passant_spot remains as nil' do
        expect(subject).to receive(:move_piece).with(board, white_king, [0, 0], [0, 1], nil)
        subject.update_board(board, white_king, [0, 0], [0, 1], nil)
      end
    end
    context 'when piece is a pawn' do
      before do
        allow(subject).to receive(:move_piece)
        allow(board).to receive(:display)
        allow(white_pawn).to receive(:move=)
        allow(white_pawn).to receive(:instance_of?).and_return(true)
        allow(board).to receive(:last_piece_moved=)
        allow(white_pawn).to receive(:instance_of?).with(King).and_return(false)
      end
      it 'assigns passant_spot if it is a valid passing move' do
        allow(white_pawn).to receive(:en_passant?).and_return([4, 5])
        allow(white_pawn).to receive(:en_passant_spot).and_return([4, 5]).once
        expect(subject).to receive(:move_piece).with(board, white_pawn, [4, 4], [5, 5], [4, 5])
        subject.update_board(board, white_pawn, [4, 4], [5, 5], nil)
      end
      it 'does not assign passant_spot if it is an invalid passing move' do
        allow(white_pawn).to receive(:en_passant?).and_return(false)
        expect(subject).to receive(:move_piece).with(board, white_pawn, [4, 4], [5, 5], nil)
        subject.update_board(board, white_pawn, [4, 4], [5, 5], nil)
      end
    end
    context 'when it is a castling move' do
      before do
        allow(subject).to receive(:move_piece)
        allow(board).to receive(:display)
        allow(white_king).to receive(:move=)
        allow(board).to receive(:last_piece_moved=)
        allow(board).to receive(:get_piece).and_return(white_rook, nil)
        allow(white_king).to receive(:instance_of?).and_return(false, true)
        allow(white_king).to receive(:castling_move?).and_return(true)
      end
      it 'calls the move_rook_for_castling method' do
        expect(subject).to receive(:move_rook_for_castling)
        subject.update_board(board, white_king, [0, 4], [0, 6], nil)
      end
    end
  end

  describe '.move_piece' do
    context 'when there is no piece in the target spot' do
      before do
        allow(board).to receive(:grid).and_return([[e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                   [e_spot, k_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                   [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                   [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                   [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                   [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                   [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                   [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot]])
        allow(board).to receive(:get_piece).with([2, 2]).and_return(nil)
        allow(k_spot).to receive(:piece=)
        allow(e_spot).to receive(:piece=)
      end
      it 'does not call the defeat_piece method' do
        subject.move_piece(board, white_king, [1, 1], [2, 2])
        expect(subject).not_to receive(:defeat_piece)
      end
    end
    context 'when there is a piece in the target spot' do
      before do
        allow(board).to receive(:grid).and_return([[e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                   [e_spot, k_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                   [e_spot, e_spot, q_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                   [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                   [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                   [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                   [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                   [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot]])
        allow(board).to receive(:get_piece).with([2, 2]).and_return(queen)
        allow(queen).to receive(:defeated=)
        allow(q_spot).to receive(:piece=)
        allow(k_spot).to receive(:piece=)
      end
      it 'calls the defeat_piece method' do
        expect(subject).to receive(:defeat_piece)
        subject.move_piece(board, white_king, [1, 1], [2, 2])
      end
      it 'sets start spot as nil' do
        expect(k_spot).to receive(:piece=).with(nil)
        subject.move_piece(board, white_king, [1, 1], [2, 2])
      end
    end
  end

  describe 'defeat_piece' do
    it 'it changes the defeated attribute on a direct capture' do
      target_spot_piece = queen
      expect(target_spot_piece).to receive(:defeated=)
      subject.defeat_piece(board, queen, nil)
    end
    it 'it changes the defeated attribute on an en passant move' do
      target_spot_piece = queen
      expect(target_spot_piece).to receive(:defeated=)
      subject.defeat_piece(board, queen, nil)
    end
  end

  describe 'own_piece?' do
    context 'piece in target spot matches player color' do
      before do
        allow(board).to receive(:get_piece).and_return(white_king)
      end
      it 'returns true' do
        expect(subject.own_piece?(player1, k_spot)).to be true
      end
    end
    context 'piece in target spot does not match player color' do
      before do
        allow(board).to receive(:get_piece).and_return(queen)
      end
      it 'returns false' do
        expect(subject.own_piece?(player1, q_spot)).to be false
      end
    end
    context 'there is no piece in the start spot' do
      before do
        allow(board).to receive(:get_piece).and_return(nil)
      end
      it 'returns false' do
        expect(subject.own_piece?(player1, e_spot)).to be false
      end
    end
  end

  describe '.eligible_for_promotion?' do
    context 'it is a white pawn at its start side of the board (bottom)' do
      it 'returns false' do
        expect(subject.eligible_for_promotion?(white_pawn, [0, 2])).to be false
      end
    end
    context 'it is a black pawn at its start side of the board (top)' do
      it 'returns false' do
        expect(subject.eligible_for_promotion?(black_pawn, [7, 4])).to be false
      end
    end
    context 'it is a black pawn opposite its start side of the board (bottom)' do
      it 'returns true' do
        expect(subject.eligible_for_promotion?(black_pawn, [0, 4])).to be true
      end
    end
    context 'it is a white pawn opposite its start side of the board (top)' do
      it 'returns true' do
        expect(subject.eligible_for_promotion?(white_pawn, [7, 2])).to be true
      end
    end
  end

  describe '.puts king in check' do
    context 'after the test board is updated, there are no legal moves to put the king in check' do
      before do
        allow(board).to receive(:active_opponent_spots).and_return([p_spot_w])
        allow(p_spot_w).to receive(:x).and_return(7)
        allow(p_spot_w).to receive(:y).and_return(2)
      end
      it 'returns false' do
        expect(subject.puts_king_in_check?([7, 2], [4, 4])).to be false
      end
    end
    context 'after the test board is updated, there is a legal move to put the king in check' do
      before do
        allow(board).to receive(:active_opponent_spots).and_return([p_spot_w, q_spot, p_spot_b, k_spot])
        allow(p_spot_w).to receive(:x).and_return(4)
        allow(p_spot_w).to receive(:y).and_return(2) 
        allow(q_spot).to receive(:x).and_return(7)
        allow(q_spot).to receive(:y).and_return(4)
        allow(p_spot_b).to receive(:x).and_return(5)
        allow(p_spot_b).to receive(:y).and_return(5)
        allow(k_spot).to receive(:x).and_return(6)
        allow(k_spot).to receive(:y).and_return(4)
        allow(queen).to receive(:legal_move?).and_return(true)
      end
      it 'returns true' do
        start_spot = [4, 2]
        end_spot = [4, 4]
        expect(subject.puts_king_in_check?(start_spot, end_spot)).to be true
      end
    end
  end

  describe '.clone board' do
    before do
      allow(board).to receive(:active_opponent_spots).and_return([p_spot_w])
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

  describe '.move_rook_for_castling' do
    before do
      allow(board).to receive(:grid).and_return([[e_spot, e_spot, e_spot, e_spot, k_spot_b, e_spot, e_spot, r_spot_b],
                                                 [e_spot, k_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                 [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                 [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                 [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                 [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                 [e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot, e_spot],
                                                 [r_spot_w, e_spot, e_spot, e_spot, k_spot, e_spot, e_spot, e_spot]])
      allow(e_spot).to receive(:piece=)
    end
    context 'moves a white rook on the left side' do
      it 'calls for the rook to be moved to the left of the king' do
        allow(white_king).to receive(:rook_spot_for_castling).and_return([0, 0])
        allow(board).to receive(:get_piece).and_return(white_rook, nil)
        expect(subject).to receive(:move_piece).with(board, white_rook, [0, 0], [0, 3])
        subject.move_rook_for_castling(board, white_king, [0, 4], [0, 2])
      end
    end
    context 'moves a black rook on the right side' do
      it 'calls for the rook to be moved to the right of the king' do
        allow(black_king).to receive(:rook_spot_for_castling).and_return([7, 7])
        allow(board).to receive(:get_piece).and_return(black_rook, nil)
        expect(subject).to receive(:move_piece).with(board, black_rook, [7, 7], [7, 5])
        subject.move_rook_for_castling(board, black_king, [7, 4], [7, 6])
      end
    end
  end

  describe '.draw?' do
    context 'it something' do
      xit 'blah bee bah' do
      end
    end
  end

  describe '.won?' do
    context 'it something' do
      xit 'blah bee bah' do
      end
    end
  end

  describe '.game_over?' do
    context 'it something' do
      xit 'blah bee bah' do
      end
    end
  end
end

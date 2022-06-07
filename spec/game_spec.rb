
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
        allow(board).to receive(:valid_move?).and_return(false)
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
        allow(board).to receive(:valid_move?).and_return(true)
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
        allow(board).to receive(:puts_king_in_check?).and_return(false)
      end
      it 'calls to update the board' do
        expect(board).to receive(:update).once
        subject.take_turn
      end
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

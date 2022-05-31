# frozen_string_literal: true

require 'game'

describe Game do
  let(:board) { Board.new }
  let(:spot) { double('spot', piece: ) }
  let(:king) { double('king', class: King, color: 'white', move: 1, defeated: false) }
  let(:queen) { double('queen', class: Queen, color: 'black', move: 1, defeated: false) }
  let(:pawn) { double('pawn', class: Pawn, color: 'white', move: 1, defeated: false) }
  let(:spot) { double('spot', piece: Pawn) }
  let(:spotk) { double('spot', piece: king) }
  let(:spotq) { double('spot', piece: queen) }
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
      it 'returns true if spots are different' do
        allow(king).to receive(:legal_move?).with(board, [2, 3], [2, 5]).and_return(true)
        expect(subject.valid_turn?(king, [2, 3], [2, 5])).to be true
      end
      it 'returns false if spots are the same' do
        allow(king).to receive(:legal_move?).with(board, [3, 4], [3, 4]).and_return(true)
        expect(subject.valid_turn?(king, [3, 4], [3, 4])). to be false
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
      allow(board).to receive(:get_piece).and_return(king)
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
        allow(board).to receive(:get_piece).and_return(king)
        allow(king).to receive(:legal_move?).with(0, 1).and_return(true)
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
        allow(subject).to receive(:gets).and_return('c8', 'd8')
        allow(board).to receive(:grid).and_return([[spot, spot, spot, spot, spot, spot, spot],
                                                   [spot, spot, spot, spot, spot, spot, spot],
                                                   [spot, spot, spot, spot, spot, spot, spot],
                                                   [spot, spot, spot, spot, spot, spot, spot],
                                                   [spot, spot, spot, spot, spot, spot, spot],
                                                   [spot, spot, spot, spot, spot, spot, spot],
                                                   [spot, spot, spot, spot, spot, spot, spot],
                                                   [spot, spot, spotk, spotq, spot, spot, spot]])
        allow(board).to receive(:get_piece).and_return(king)
        allow(king).to receive(:legal_move?).and_return(false, true)
        # allow(king).to receive(:move=)
        # allow(subject).to receive(:defeat_piece).with(queen, nil)
        # allow(queen).to receive(:defeated=)
        # allow(board).to receive(:display)
      end
      it 'puts illegal move message' do
        subject.instance_variable_set(:@turn, 1)
        # allow(subject).to receive(:valid_turn?).and_return(false, true)
        expect(subject.take_turn).to receive(:puts)
        subject.take_turn
      end
      xit 'restarts the loop' do
        expect(subject.take_turn).to receive(:update_board).once
        subject.take_turn
      end
    end
    context 'when turn is valid' do
      # allow(subject).to receive(:valid_turn?).and_return(false)
      xit 'calls to update the board' do
      end
      xit 'stops the loop' do
      end
    end
  end

  describe '.update_board' do
    context 'when piece is not a pawn' do
      before do
        allow(subject).to receive(:move_piece)
        allow(board).to receive(:display)
        allow(king).to receive(:move=)
      end
      it 'increments the turn counter' do
        subject.instance_variable_set(:@turn, 1)
        subject.update_board(king, [0, 0], [0, 1])
        expect(subject.instance_variable_get(:@turn)).to eq(2)
      end
      it 'passant_spot remains as nil' do
        expect(subject).to receive(:move_piece).with(king, [0, 0], [0, 1], nil)
        subject.update_board(king, [0, 0], [0, 1])
      end
    end
    context 'when piece is a pawn' do 
      before do
        allow(subject).to receive(:move_piece)
        allow(board).to receive(:display)
        allow(pawn).to receive(:move=)
        allow(pawn).to receive(:instance_of?).and_return(true)
      end
      it 'assigns passant_spot if it is a valid passing move' do
        allow(pawn).to receive(:en_passant?).and_return(true) 
        allow(pawn).to receive(:en_passant_spot).and_return([4, 5]).once
        expect(subject).to receive(:move_piece).with(pawn, [4, 4], [5, 5], [4, 5])
        subject.update_board(pawn, [4, 4], [5, 5])
      end
      it 'does not assign passant_spot if it is an invalid passing move' do 
        allow(pawn).to receive(:en_passant?).and_return(false)
        expect(subject).to receive(:move_piece).with(pawn, [4, 4], [5, 5], nil)
        subject.update_board(pawn, [4, 4], [5, 5])
      end
    end
  end

  describe '.move_piece' do
    context 'it does somthing' do
      xit 'blah blah' do
      end
    end
  end
  describe 'defeat_piece' do
    context 'it blah' do
      xit 'something' do
      end
    end
  end
  describe 'own_piece?' do
    context 'it something' do
      xit 'blah bee bah' do
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

# frozen_string_literal: true

require 'game'

describe Game do
  let(:board) { double('board') }
  let(:spot) { double('spot') }
  let(:king) { double('king', class: King, color: 'white') }
  let(:player1) { double('player1', name: 'Dingo', color: 'white') }
  let(:player2) { double('player2', name: 'Huckleberry', color: 'black') }
  subject(:game) { described_class.new(player1, player2, board) }

  context 'initializer' do
    it 'gets created' do
      expect(subject).to be_a(Game)
    end
  end

  xdescribe '.draw?' do
  end

  xdescribe '.won?' do
  end

  xdescribe '.game_over?' do
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

  xdescribe '.take_turn' do
  end

  xdescribe '.update_board' do
  end
end

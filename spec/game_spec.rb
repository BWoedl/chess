# frozen_string_literal: true

require 'game'

describe Game do
  let(:board) { double('board') }
  let(:king) { double('king', class: King) }
  let(:rook) { double('rook', class: Rook) }
  let(:spot) { double('spot') }
  let(:spot1) { double('spot', piece: king) }
  let(:spot2) { double('spot', piece: rook) }
  let(:player1) { double('player1', name: 'Dingo') }
  let(:player2) { double('player2', name: 'Huckleberry') }
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

  describe '.convert_to_coordinates' do
    it 'returns a 2d array with 2 sets of x, y coordinates corresponding to 8x8 grid' do
      input = %w[b4 f6]
      expect(subject.convert_to_coordinates(input)).to eq([[3, 1], [5, 5]])
    end
  end

  describe '.get_piece' do
    context 'when a king is in the spot on the board' do
      it 'returns king class' do
        allow(board).to receive(:grid).and_return([[spot2, spot, spot, spot, spot1, spot, spot],
                                                   [spot, spot, spot, spot, spot, spot, spot],
                                                   [spot, spot, spot, spot, spot, spot, spot],
                                                   [spot, spot, spot, spot, spot, spot, spot],
                                                   [spot, spot, spot, spot, spot, spot, spot],
                                                   [spot, spot, spot, spot, spot, spot, spot]])
        expect(subject.get_piece([[0, 4], [5, 5]])).to match(King)
      end
    end

    context 'when a rook is in the spot on the board ' do
      it 'returns rook class' do
        allow(board).to receive(:grid).and_return([[spot2, spot, spot, spot, spot1, spot, spot],
                                                   [spot, spot, spot, spot, spot, spot, spot],
                                                   [spot, spot, spot, spot, spot, spot, spot],
                                                   [spot, spot, spot, spot, spot, spot, spot],
                                                   [spot, spot, spot, spot, spot, spot, spot],
                                                   [spot, spot, spot, spot, spot, spot, spot]])
        expect(subject.get_piece([[0, 0], [5, 5]])).to match(Rook)
      end
    end
  end

  describe '.spot_to_move' do
    it 'returns an array where valid user input is pushed into argument array' do
      allow(subject).to receive(:puts)
      allow(subject).to receive(:gets).and_return('a4')
      expect(subject.spot_to_move(['b2'])).to eq(['b2', 'a4'])
    end
  end

  describe '.piece_to_move' do
    it 'returns an array with valid user input' do
      allow(subject).to receive(:puts)
      allow(subject).to receive(:gets).and_return('b4')
      expect(subject.piece_to_move).to eq(['b4'])
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
        allow(subject).to receive(:get_piece).and_return(king)
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

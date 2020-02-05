require_relative '../spec_helper'

describe ::Command::New do
  describe '#initialize' do
    subject { ::Command::New.new(command_params: command_params, params: params) }

    let(:command_params) { ['2'] }
    let(:params) { nil }

    shared_examples 'default to 4 players' do
      it 'set the number of players to 4' do
        expect(subject.nb_players).to eq(4)
      end
    end

    it 'sanitizes the command params to set the nb players' do
      expect(subject.nb_players).to eq(2)
    end

    describe 'when the command params are nil' do
      let(:command_params) { nil }

      include_examples 'default to 4 players'
    end

    describe 'when the command params is not an array' do
      let(:command_params) { :test }

      include_examples 'default to 4 players'
    end

    describe 'when command params is an array with a length > 1' do
      describe 'when the command params are nil' do
        let(:command_params) { [1, 2] }

        include_examples 'default to 4 players'
      end
    end

    describe 'when the only element of the command params is lower than 0' do
      describe 'when the command params are nil' do
        let(:command_params) { ["-1"] }

        include_examples 'default to 4 players'
      end
    end

    describe 'when the only element of the command params is greater than 4' do
      describe 'when the command params are nil' do
        let(:command_params) { ["5"] }

        include_examples 'default to 4 players'
      end
    end

    describe 'when the only element of the command params is a non numerical string' do
      describe 'when the command params are nil' do
        let(:command_params) { ["asb"] }

        include_examples 'default to 4 players'
      end
    end
  end
end
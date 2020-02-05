require_relative '../spec_helper'

describe Player do
  describe '#save_elo!' do
    subject { player.save_elo!(elo) }

    let(:player) { Player.create(username: 'TOTO', highest_elo: highest_elo, lowest_elo: lowest_elo) }
    let(:elo) { 1030 }
    let(:highest_elo) { nil }
    let(:lowest_elo) { nil }

    it 'saves the elo' do
      expect { subject }.to change { player.reload.elo }.from(1000).to(1030)
    end

    describe 'when this is the first time a elo is saved for the player' do
      let(:highest_elo) { nil }
      let(:lowest_elo) { nil }

      it 'saves the highest elo and the lowest elo using the current elo' do
        expect { subject }.to change{ [player.reload.highest_elo, player.lowest_elo]}.from([nil, nil]).to([1030, 1030])
      end
    end

    describe 'when the elo is higher than the highest elo' do
      let(:highest_elo) { 1000 }

      it 'updates the highest elo with the current elo' do
        expect { subject }.to change { player.reload.highest_elo }.from(1000).to(1030)
      end
    end

    describe 'when the elo is lower than the lowest elo' do
      let(:lowest_elo) { 1200 }

      it 'updates the highest elo with the current elo' do
        expect { subject }.to change { player.reload.lowest_elo }.from(1200).to(1030)
      end
    end
  end
end
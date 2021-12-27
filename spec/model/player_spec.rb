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

  describe '#already_got_free_option_today?' do
    subject { player.already_got_free_option_today? }
    
    let(:player) { Player.create(username: 'TOTO') }
    context "player has not taken the free option today" do
      it 'it should return false' do
        expect(subject).to eq(false)
      end
    end

    context "when player has taken the free option" do
      let(:free_option) { MoneyOption.create(title: 'Free', price: 0, value: 5, active: true) }

      context "today" do
        before { player.money_options << free_option }

        it "should return true" do
          expect(subject).to eq(true)
        end
      end

      context "more than 1 day ago" do
        before do 
          Timecop.travel(24.hours.ago)
          player.money_options << free_option
          Timecop.return
        end

        it "it should return false" do
          expect(player.money_options.count).to eq(1)
          expect(subject).to eq(false)
        end
      end

      context "multiple time" do
        before do 
          Timecop.travel(3.days.ago)
          player.money_options << free_option

          Timecop.travel(2.days.ago)
          player.money_options << free_option

          Timecop.travel(25.hours.ago)
          player.money_options << free_option

          expect(player.money_options.count).to eq(3)
        end

        context "today included" do
          before { player.money_options << free_option }

          it "it should return true" do
            expect(subject).to eq(true)
          end
        end

        context "but today" do
          before do 
            Timecop.travel(24.hours.ago)
            player.money_options << free_option
            Timecop.return
          end

          it "it should return false" do
            expect(subject).to eq(false)
          end
        end
      end
    end

    context "player has taken another option" do
      let(:not_free_option) { MoneyOption.create(title: 'Not Free', price: 1, value: 5, active: true) }

      before { player.money_options << not_free_option }

      it "should return false" do
        expect(subject).to eq(false)
      end
    end
  end

  describe '#last_paid_free_option' do 
    subject { player.last_paid_free_option }
    
    let(:player) { Player.create(username: 'TOTO') }

    context "when no option" do
      it "it should return nil" do
        expect(subject).to eq(nil)
      end
    end

    context "when one option is taken" do
      let(:option) { MoneyOption.create(title: 'Free', price: price, value: 5, active: true) }
      let(:price) { 0 }

      before { player.money_options << option }

      it "should return the option" do
        expect(subject).to eq(player.players_money_options.last)
      end

      context "but is not free" do
        let(:price) { 10 }

        it "should return nil" do
          expect(subject).to eq(nil)
        end
      end
    end

    context "when multiple options are taken" do
      let(:option) { MoneyOption.create(title: 'Free', price: 0, value: 5, active: true) }
      let(:option1) { MoneyOption.create(title: 'Free', price: 10, value: 5, active: true) }

      before do 
        player.money_options << option
        player.money_options << option
        player.money_options << option1
      end

      it "should return the last free one" do
        expect(subject).not_to eq(nil)
        expect(subject.money_option.price).to eq(0)

        last = player.players_money_options.free.last
        expect(subject).to eq(last)
      end
    end
  end
end
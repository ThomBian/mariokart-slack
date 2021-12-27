require_relative '../spec_helper'

describe MoneyOption do
    describe "#free" do
        subject { option.free? }

        let(:option) { MoneyOption.create(title: 'option', price: price) }
        let(:price) { 0 }

        context "when the price is 0" do
            let(:price) { 0 }

            it "it should return true" do
                expect(subject).to eq(true)
            end
        end

        context "when the price is not 0" do
            let(:price) { 10 }
            
            it "it should return false" do
                expect(subject).to eq(false)
            end
        end
    end
end
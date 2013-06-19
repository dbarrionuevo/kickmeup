require 'spec_helper'
describe User do
  let!(:user) { create(:user) }
  let!(:own_idea) { create(:idea, user_id: user.id) }
  let!(:idea) { create(:idea) }

  describe "Validations" do
    it{ should validate_presence_of :uid }
    it{ should validate_presence_of :name }
    it{ should validate_presence_of :email }
  end

  describe "#author_of?" do
    it { expect(user.author_of? own_idea).to be_true }
    it { expect(user.author_of? idea).to be_false }
  end

  describe "#has_kicked_ideas" do
  end
end

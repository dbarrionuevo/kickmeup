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

  describe "facebook" do
    let(:friends) do
      { "name" => "Alexander Bond", "username" => "alexbond", "id" => "1252345" }
    end

    before do
      @graph = Koala::Facebook::API
      @graph.should_receive(:new).with(user.oauth_token).and_return(Koala::Facebook::API)
    end

    it "#facebook" do
      user.facebook
    end

    it "#friendships" do
      @graph.should_receive( :fql_query ).and_return(friends)
      expect( user.friendships ).to eq friends
    end
  end
end

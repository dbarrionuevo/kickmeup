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

  describe "Facebook Integration" do
    let(:recipients) { ["recip1@facebook.com", "recip2@facebook.com", "102032@facebook.com"] }
    let(:invites) {
      {
        "102030" => "recip1",
        "102031" => "recip2",
        "102032" => ""
      }
    }

    describe "#recipients" do
      it "returns an email collection with the format username@facebook.com" do
        expect( user.recipients(invites) ).to match_array recipients
      end
    end

    context "Graph API" do

      let(:friends) do
        [
          { "name" => "Alexander Bond", "username" => "alexbond", "id" => "1252345" },
          { "name" => "Alexander Bond", "username" => "alexbond", "id" => "1252345" }
        ]
      end

      before do
        @graph = Koala::Facebook::API
        @graph.should_receive(:new).with(user.oauth_token).and_return(Koala::Facebook::API)
      end

      describe "#facebook" do
        it "initialize Koaka gem" do
          user.facebook
        end
      end

      describe "#friendships" do
        it "returns a collection with current user's friendships" do
          @graph.should_receive( :fql_query ).and_return(friends)

          expect( user.friendships ).to eq friends
        end
      end

    end

  end
end

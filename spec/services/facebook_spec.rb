require 'spec_helper'

describe Facebook do
  let(:graph) { Facebook.new(current_user) }
  let(:friends) do
    [
      { "name" => "Alexander Bond", "username" => "alexbond", "id" => "1252345" },
      { "name" => "James Bond", "username" => "jamesbond", "id" => "1252347" }
    ]
  end

  before do
    load_facebook_auth_data( save_user: true )
    stub_graph(with_friends: true)
  end

  context "when username is public" do
    let(:recipients) { ["recip1@facebook.com", "recip2@facebook.com"] }
    let(:invites) do
      {
        "102030" => "recip1",
        "102031" => "recip2"
      }
    end

    it "returns an email collection with the format username@facebook.com" do
      expect( graph.recipients(invites) ).to eq recipients
    end
  end

  context "when username is not public" do
    let(:recipients) { ["102030@facebook.com", "102031@facebook.com"] }
    let(:invites) do
      {
        "102030" => "",
        "102031" => ""
      }
    end

    it "returns an email collection with the format uid@facebook.com" do
      expect( graph.recipients(invites) ).to eq recipients
    end
  end

  it "returns a collection with current user's friendships" do
    expect( graph.friendships ).to eq friends
  end
end

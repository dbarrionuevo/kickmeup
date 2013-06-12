require 'spec_helper'

describe Idea do
  let(:idea) { Idea.create!(user_id: 123456, title: 'Existing Idea Title', description: 'Existing Idea description') }
  
  it "creates kicked_ideas once for a user" do
    idea.user_kicked = current_user
    idea.kickup
    idea.save!
    idea.reload.kickups.should == 1
    
    idea.kickup
    idea.save!
    idea.reload.kickups.should == 1
  end
end

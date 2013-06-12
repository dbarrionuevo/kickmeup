require 'spec_helper'

describe Idea do
  let(:idea) { Idea.create!(user_id: 123456, title: 'Existing Idea Title', description: 'Existing Idea description') }
  
  describe "Validations" do
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
  end

  describe "Associations" do
    it { should have_many :kicked_ideas }
  end

  describe "#kickup" do
    context "with logged user" do
      before {
        load_facebook_auth_data
        idea.user_kicked = current_user
        idea.kickup
      }

      it "creates current user kicked idea once" do
        expect{ 
          idea.save! 
        }.to change{ idea.kicked_ideas.count }.by(1)

        idea.kickup
        expect{
          idea.save!
        }.to_not change{ idea.kicked_ideas.count }
      end

      it "increments kickups count once" do
        idea.save!
        expect(idea.reload.kickups).to eq(1)

        idea.kickup.save!
        expect(idea.reload.kickups).to eq(1)
      end
    
    end

    context "with guest user" do
      it "doesn't kickup" do
        idea.kickup
        idea.save!
        expect(idea.reload.kickups).to be_zero
      end
    end
  end
end


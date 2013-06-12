require 'spec_helper'

describe Idea do
  let(:idea) { Idea.create!(user_id: 123456, title: 'Existing Idea Title', description: 'Existing Idea description') }
  
  def load_user_kicked
    load_facebook_auth_data
    idea.user_kicked = current_user
  end

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
        load_user_kicked
        idea.kickup
      }

      it "creates kicked idea once for the user" do
        expect{ 
          idea.save! 
        }.to change{ idea.kicked_ideas.count }.from(0).to(1)

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

      it "returns self" do
        expect( idea.kickup ).to be_a(Idea)
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

  describe "#already_kicked_by_user?" do
    before { load_user_kicked }

    it "returns true when user already kiked an idea" do
      idea.kickup
      idea.save!

      expect( idea.already_kicked_by_user? ).to be_true
    end

    it "return false when user kicks for first time" do
      expect( idea.already_kicked_by_user? ).to be_false
    end
  end

  describe "#build_kicked_idea" do
    before { load_user_kicked }

    it "creates new kicked_ideas record for the idea" do
      expect(idea.kicked_ideas).to be_empty

      expect{ 
        idea.build_kicked_ideas
        idea.save!
      }.to change{ idea.kicked_ideas.count }.by(1)
    end
  end
end


require 'spec_helper'

feature "Facebook login" do
	context "successfully" do
		scenario "sign in with facebook account" do
			visit root_path

			load_facebook_auth_data

			click_link "Sign in with Facebook"

			expect(page).to have_content("Signed in as #{current_user}")

			expect(User.where(email: current_user.email)).to exist
			expect(User.last.provider).to eql("facebook")
			expect(User.last.uid).to eql(current_user.uid)
			expect(current_path).to eql root_path
		end

		scenario "creates user slug with name when nickname is not present" do
			load_facebook_auth_data( valid:true, user: { name: 'John Doe', nickname: nil } )

			visit root_path
			click_link "Sign in with Facebook"

			expect( User.where(slug: 'john-doe') ).to exist
		end

		scenario "creates user slug with nikname when present" do
			load_facebook_auth_data( valid:true, user: { name: 'John Doe', nickname: 'jdoe-1' } )

			visit root_path
			click_link "Sign in with Facebook"

			expect( User.where(slug: 'jdoe-1') ).to exist
			expect( User.where(slug: 'john-doe') ).to_not exist
		end
	end


	scenario "fail to sign in with Facebook account" do
		visit root_path

		load_facebook_auth_data(valid: false)

		click_link "Sign in with Facebook"

		expect(User.count).to eq(0)
	end

	scenario "successfully sign out" do
		sign_in
		click_link 'Sign out'

		expect(page).to have_content('Sign in')
		current_path.should eq root_path
	end
end

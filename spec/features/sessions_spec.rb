require 'spec_helper'

feature "Facebook login" do

	scenario "successfully sign in with facebook account" do
		sign_in
		expect(page).to have_content("Signed in as #{current_user.email}")
		expect(page).to have_link("Sign out")
		current_path.should eq root_path
	end

	scenario "fail to sign in with Facebook account" do
		sign_in(false)
		pending
	end

	scenario "successfully sign out" do
		sign_in
		click_link 'Sign out'

		expect(page).to have_content('Sign in')
		current_path.should eq root_path
	end
end
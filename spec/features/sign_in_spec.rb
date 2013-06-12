require 'spec_helper'

feature "Facebook login" do
	include_context 'facebook login'

	scenario "successfully sign in with facebook account" do
		login
		page.should have_content("Signed in as #{current_user.email}")
		current_path.should eq root_path
	end

	scenario "fail to sign in with Facebook account" do
		login(false)
    pending
	end

	scenario "successfully sign out" do
		login
		click_link 'Sign out'

		page.should have_content('Sign in')
		current_path.should eq root_path
	end
end
require 'spec_helper'

feature "Facebook login" do

	scenario "successfully sign in with facebook account" do
		visit root_path

    load_facebook_auth_data

    click_link "Sign in with Facebook"

		expect(page).to have_content("Signed in as #{current_user.email}")

		expect(User.where(email: current_user.info.email)).to exist
		expect(User.last.provider).to eql("facebook")
		expect(User.last.uid).to eql(current_user.uid)
		expect(current_path).to eql root_path
	end

	scenario "fail to sign in with Facebook account" do
		visit root_path

    load_facebook_auth_data(false)

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

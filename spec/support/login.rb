shared_context 'facebook login' do
	background { visit root_path }

	def login( valid=true )
		load_facebook_auth_data(valid)
		click_link "Sign in with Facebook"
	end
end
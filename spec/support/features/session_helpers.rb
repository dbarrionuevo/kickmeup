module Features
  module SessionHelpers

    def sign_in( valid=true )
      visit root_path
      load_facebook_auth_data(valid)
      click_link "Sign in with Facebook"
    end    
    
  end
end
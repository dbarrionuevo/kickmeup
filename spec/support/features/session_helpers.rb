module Features
  module SessionHelpers

    def sign_in( opts={valid: true} )
      visit root_path
      load_facebook_auth_data(opts)
      click_link "Sign in with Facebook"
    end

  end
end

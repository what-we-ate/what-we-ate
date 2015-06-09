module FeatureHelpers
  def sign_in(user = FactoryGirl.create(:user))
    visit user.is_a?(User) ? new_user_session_path : new_admin_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end

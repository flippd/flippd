module Helpers
  def sign_in(from: '/')
    OmniAuth.config.test_mode = false
    visit from
    click_on 'Sign In' if page.has_link?('Sign In')
          
    fill_in 'Name', with: 'Joe Bloggs'
    fill_in 'Email', with: 'joe@bloggs.com'
    click_on 'Sign In'
  end

  def fail_to_sign_in(from: '/')
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:developer] = 'Invalid credentials'.to_sym
    visit from
    click_on 'Sign In' if page.has_link?('Sign In')
  end
  
  def sign_out
    click_on 'Sign Out'
  end
end

OmniAuth.config.logger.level = Logger::UNKNOWN

feature "Signing in" do
  # before :each do
  #   User.make(:email => 'user@example.com', :password => 'password')
  # end

  it "shows a sign in link" do
    visit '/'
    expect(page).to have_content 'Sign in'
  end
end

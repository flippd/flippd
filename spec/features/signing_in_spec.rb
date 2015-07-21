feature "Signing in" do
  # before :each do
  #   User.make(:email => 'user@example.com', :password => 'password')
  # end

  it "shows a sign in link" do
    visit '/'
    expect(page).to have_content 'Sign in'
  end
  
  it "displays name once signed in" do
    visit '/'
    click_on 'Sign in'
    
    fill_in 'Name', with: 'Joe Bloggs'
    fill_in 'Email', with: 'joe@bloggs.com'
    click_on 'Sign In'
    
    expect(current_path).to eq('/')
    expect(page).to have_content 'Joe Bloggs'
  end
end

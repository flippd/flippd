feature "Signing in" do
  context "as a visitor" do
    it "shows a sign in link" do
      visit '/'
      expect(page).to have_content 'Sign In'
    end
  end
  
  context "when signed in" do
    before(:each) do
      visit '/'
      click_on 'Sign In'
      
      fill_in 'Name', with: 'Joe Bloggs'
      fill_in 'Email', with: 'joe@bloggs.com'
      click_on 'Sign In'
    end

    it "redirects to root" do
      expect(current_path).to eq('/')
    end
  
    it "displays the user's name" do
      expect(page).to have_content 'Joe Bloggs'
    end
    
    it "displays a sign out link" do
      expect(page).to have_content 'Sign Out'
    end
    
    it "displays a sign in link after signing out" do
      click_on 'Sign Out'
      
      expect(page).to have_content 'Sign In'
    end
  end
  
  context "when signing in with invalid credentials" do
    before(:each) do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:developer] = 'Invalid credentials'.to_sym
      
      visit '/'
      click_on 'Sign In'
    end
    
    it "redirects to root" do
      expect(current_path).to eq('/')
    end
    
    it "displays the error" do
      expect(page).to have_content 'Invalid credentials'
    end
    
    it "displays a sign in link" do
      expect(page).to have_content 'Sign In'
    end
  end
  
  xit "should redirect to current page after signing in (with valid or invalid credentials)"
  xit "should redirect to current page after signing out"
end

feature "Signing out" do
  before(:each) { sign_in }
  
  it "displays a sign in link after signing out" do
    sign_out
    expect(page).to have_content 'Sign In'
  end
  
  context "redirects" do
    it "to the current page after signing out" do
      visit '/video/complexity_2'
      sign_out
      expect(current_path).to eq('/video/complexity_2')
    end
    
    it "to the root page after signing out directly" do
      visit '/auth/destroy'
      expect(current_path).to eq('/')
    end
  end
end

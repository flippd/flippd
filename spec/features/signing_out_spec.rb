feature "Signing out" do
  before(:each) { sign_in }

  it "displays a sign in link after signing out" do
    sign_out
    expect(page).to have_content 'Sign In'
  end

  context "redirects" do
    it "to the current page after signing out" do
      visit '/videos/1'
      sign_out
      expect(current_path).to eq('/videos/1')
    end

    it "to the root page after signing out directly" do
      visit '/auth/destroy'
      expect(current_path).to eq('/phases/fundamentals')
    end
  end
end

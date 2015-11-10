feature "Signing in" do
  context "with valid credentals" do
    before(:each) { sign_in }

    it "displays the user's name" do
      expect(page).to have_content 'joe@bloggs.com'
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
    before(:each) { fail_to_sign_in }

    it "displays the error" do
      expect(page).to have_content 'Invalid credentials'
    end

    it "displays a sign in link" do
      expect(page).to have_content 'Sign In'
    end
  end

  context "redirects" do
    it "to the current page after signing in" do
      sign_in from: '/videos/1'
      expect(current_path).to eq('/videos/1')
    end

    it "to the current page after failing to sign in" do
      fail_to_sign_in from: '/videos/1'
      expect(current_path).to eq('/videos/1')
    end

    it "to the root page after signing in directly" do
      sign_in from: '/auth/new'
      expect(current_path).to eq('/')
    end

    it "to the root page after failing to sign in directly" do
      fail_to_sign_in from: '/auth/new'
      expect(current_path).to eq('/')
    end
  end
end

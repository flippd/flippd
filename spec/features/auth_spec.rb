feature "Not authorized for student pages" do
  before(:each) { visit('comment/new') }

  it "renders error 401" do
    expect(page).to have_content 'Error 401, Unauthorised'
    #This should check for error code rather than text on page
  end
end

feature "New comment user privilages" do
  before(:each) {
    sign_in
    visit('comment/new') }

  it "Checks the page for adding comments shows up" do
    expect(page).to_not have_content 'Error 401'
  end
end

feature "Editing comment user privilages" do
  context ' if not signed in' do
    before(:each) {
      visit('comment/edit/1')
    }
    it ' ' do
      expect(page).to have_content 'Error 401, Unauthorised'
    end
  end

  context ' with student credentials' do
    before(:each) {
      sign_in
    }
    it "being allowed to edit their own comment" do
      @original = Comment::create(
        :user => @user,
        :text => "Hello world.",
        :videoId => 1,
      )
      visit('comment/edit/' + @original.id.to_s)
      expect(page).to_not have_content 'Error 403'
    end

    it "checks if student is not allowed to edit somebody else's comment" do
      #Another created the comment
      @john = User::create(
        :name    => "John",
        :email   => "j.doe@york.ac.uk",
      )
      @original = Comment::create(
        :user => @john,
        :text => "Hello world.",
        :videoId => 1,
      )
      visit('comment/edit/' + @original.id.to_s)
      expect(page).to have_content 'Error 403'
    end
  end

  context 'with lecturer credentials' do
    before(:each) {
      sign_in_lecturer
      #Another created the comment
      @john = User::create(
        :name    => "John",
        :email   => "j.doe@york.ac.uk",
      )
      @original = Comment::create(
        :user => @john,
        :text => "Hello world.",
        :videoId => 1,
      )
      visit('comment/edit/' + @original.id.to_s)
    }
    it "check if lecturer is allowed to edit any comment" do
      expect(page).to_not have_content 'Error 403'
    end
  end
end

feature "User email tests" do
  before(:each) { sign_in }

  it "checks the student is not a lecturer" do
    student_email = "abaj500@york.ac.uk"
    user = User.new
    user.email = student_email
    expect(false).to eq user.is_lecturer
  end

  it "checks the lecturer is a lecturer" do
    student_email = "abaj.asdf@york.ac.uk"
    user = User.new
    user.email = student_email
    expect(true).to eq user.is_lecturer
  end

  #
  # it "Student & Lecturer email authorization" do
  #     lecturer_email = "louis.rowe@york.ac.uk"
  # end

end

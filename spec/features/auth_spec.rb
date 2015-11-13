feature "Not authorized for student pages" do
  before(:each) { visit('comment/new') }

  it "renders error 401" do
    expect(page).to have_content 'Error 401, Not authorized'
    #This should check for error code rather than text on page
  end

end

feature "User email tests" do
  before(:each) { sign_in }

  it "checks the student is not a lecture" do
    student_email = "abaj500@york.ac.uk"
    user = User.new
    user.email = student_email
    expect(false).to eq user.is_lecturer
  end
  #
  # it "Student & Lecturer email authorization" do
  #     lecturer_email = "louis.rowe@york.ac.uk"
  # end

end

feature "A video page" do
  before(:each) do

    @john = User::create(
      :name    => "John",
      :email   => "j.doe@york.ac.uk",
    )

    @bob = User::create(
      :name    => "Bob",
      :email   => "b.smith@york.ac.uk",
    )

    @original = Comment::create(
      :user => @john,
      :text => "Hello world.",
      :videoId => 2,
      :videoTime => 90,
    )

    @reply = @original.add_reply @bob, "Hi to u"

    visit('/videos/2')
  end

  it "contains the video comments" do
    within('body') do
      expect(page).to have_content 'Hello world.'
    end
  end

  it "contains the reply to the comment" do
    within('body') do
      expect(page).to have_content 'Hi to u'
    end
  end

  it "contains the video time in the correct format" do
    within('body') do
      expect(page).to have_content '1m30s'
    end
  end

  context "after some modifications to the comments" do

    before(:each) do
      @result = @reply.edit_comment @john, "Hi to you"
      @original.edit_video_time 120
      visit('/videos/2')
    end

    it "contains the reply to the comment (database)" do
      within('body') do
        expect(page).to have_content 'Hi to you'
      end
    end

    it "contains the new video time in the correct format" do
      within('body') do
        expect(page).to have_content '2m00s'
      end
    end

  end
end

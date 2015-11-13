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
      :videoId      => 2,
      :user         => @john,
      :text         => "Hello world."
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

  context "after some modification" do

    before(:each) do
      @reply.edit_comment @john, "Hi to you"
      visit('/videos/2')
    end

    it "contains the reply to the comment" do
      within('body') do
        expect(page).to have_content 'Hi to you'
      end
    end

  end
end

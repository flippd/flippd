# Req. 1 - support formative mini-quiz assignments
feature "A multiple choice test page" do
    include Rack::Test::Methods

    def app
        Flippd
    end

    #Checking the cohesion quiz page
	before(:each) { visit('/quizzes/24') }

	#checks the page has the expected title
	it "contains the test's title" do
		within ('h1') do
			expect(page).to have_content 'Cohesion Formative Quiz'
		end
	end

	#check the various elements expected on the page
	#there may be more appropriate methods, as suggested below
	it "contains a form" do
		expect(page).to have_xpath '//form'
	end

	it "contains at least one radio input" do
		expect(page).to have_xpath '//input[@type="radio"]'
	end

	it "contains a submit button" do
		expect(page).to have_xpath '//button[@type="submit"]'
	end

    # Req 2. Flippd self marks the quizzes by comparing

    # Selected answers to correct answers
    # Req 5. Flippd returns the sum total of correct answers over total questions
    it "rewards marks a correct answer" do
        post "/quizzes/24", params={:id=>"24", :post=>{"0"=>"A", "1"=>"A"}}
        expect(last_response.ok?).to eq(true)
        print last_response.body
        expect(last_response.body).to have_content("Score: 2 / 2")
    end

    # Req 3. Flippd provides justification when an answer is incorrect
    it "punishes and justifies an incorrect answer" do
        post "/quizzes/24", params={:id=>"24", :post=>{"0"=>"B", "1"=>"A"}}
        expect(last_response.ok?).to eq(true)
        expect(last_response.body).to have_content("Score: 1 / 2")
        expect(last_response.body).to have_xpath '//span[@class="help_block"]'
    end

# Req 4. Provide links to the previous/ next topic (quiz? FIXME)
    it "has link to the previous video" do
        expect(page).to have_link "Getting cohesion", href: "/videos/23"
    end

    it "has links to the next video" do
        expect(page).to have_link "Why clarity?", href: "/videos/25"
    end

# Req 6. 
    it "renders HTML from the quiz template" do
        expect(page).to have_xpath '/html'
    end
    
end

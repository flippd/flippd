# Req. 1 - support formative mini-quiz assignments
feature "A multiple choice test page" do
	#checks code at url/test/1
	before(:each) { visit('/test/1') }

	#checks the page has the expected title
	it "contains the test's title" do
		within ('#main h1') do
			expect(page).to have_content 'Habitability Factors'
		end
	end

	#check the various elements expected on the page
	#there may be more appropriate methods, as suggested below

	it "contains a form" do
		expect(page).to have_content '<form>'
		#expect(page).to have_form?
	end

	it "contains at least one radio input" do
		expect(page).to have_content 'input type="radio"'
		#expect(page).to have_input?
	end

	it "contains a submit button" do
		expect(page).to have_content 'input type="submit"'
		#expect(page).to have_input?
	end

# Req 2. Flippd self marks the quizzes by comparing
# Selected answers to correct answers
    it "rewards marks a correct answer" do
        expect(quiz.mark("expected_answer", "expected_answer") to eq(True)
    end

    # Req 3. Flippd provides justification when an answer is incorrect
    it "punishes and justifies an incorrect answer" do
        expect(quiz.mark("given_answer", "expected_answer") to eq(False)
        expect(quiz.justify("given answer", "expected answer" to eq("content")
        quiz.update_page()
        expect(page).to have_content("justification")
    end
# Req 5. Returns a score upon submission
    it "returns the sum total of given marks over total marks" do
        expect(quiz.score() to eq ("1/2")
    end

    it "updates the view to show the score" do
        quiz.update_page()
        expect(page).to have_content ("Marks")
    end

# Req 4. Provide links to the previous/ next topic
    it "has links to review the lecture" do
        expect(page).to have_link "lecture", href: "/videos/lecture"
    end

    it "has links to the next lecture" do
        expect(page).to have_link "next", href: "/videos/next"
    end

    it "has a button to restart the test" do
        #reset button?
        expect(page).to have_content "input type=submit"
    end
    
# Req 6. 
    it "renders HTML from the quiz template" do
        expect(page).to_have css 'h1'
    end
    
end

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
end

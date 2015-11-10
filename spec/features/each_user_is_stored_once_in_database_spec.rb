# This is a slightly odd feature right now, because we inspect the state of the
# database to check that results are correct. In a future version of Flippd,
# perhaps it would make sense to instead provide a view (only for module leaders)
# that lists all of the users for that VLE. These tests can then be rewritten to
# inspect the content of a web page rather than reaching into the database.

feature "Each user is stored once in database" do
  context "after signing in once" do
    it "the database contains the user once rather than not at all" do
      expect { sign_in }.to change { User.count }.from(0).to(1)
    end
  end

  context "after signing in twice" do
    it "the database contains the user only once" do
      expect { sign_in_twice }.to change { User.count }.from(0).to(1)
    end

    def sign_in_twice
      sign_in
      sign_out
      sign_in
    end
  end
end

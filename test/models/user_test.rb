require 'test_helper'

describe User do
  describe "relations" do
    it "has a list of votes" do
      dan = users(:dan)
      dan.must_respond_to :votes
      dan.votes.each do |vote|
        vote.must_be_kind_of Vote
      end
    end

    it "has a list of ranked works" do
      dan = users(:dan)
      dan.must_respond_to :ranked_works
      dan.ranked_works.each do |work|
        work.must_be_kind_of Work
      end
    end

    it "has a list of works" do
      dan = users(:dan)
      dan.must_respond_to :works
      dan.works.each do |work|
        work.must_be_kind_of Work
      end
    end
  end

  describe "validations" do
    it "requires a username" do
      user = User.new
      user.valid?.must_equal false
      # user.errors.messages.must_include :username, :email, :uid, :provider
    end

    it "requires a unique username" do
      username = "test username"
      user1 = User.new(username: username, uid: 1234, provider: 'github', email: "user1@test.com")

      # This must go through, so we use create!
      user1.save!

      user2 = User.new(username: username, uid: 6789, provider: 'github', email: "user2@test.com")
      result = user2.save
      result.must_equal false
      user2.errors.messages.must_include :username
    end
  end

  describe "build_from_github(auth_hash)" do
    it "builds a user from an auth_hash" do
      mock_auth_hash = {
        provider: 'github',
        uid: 123567,
        "info" => {
          "email" => "blank@blank.com",
          "name" => "jane"
        }
      }
      user = User.build_from_github(mock_auth_hash)
      user.must_be_kind_of User
    end
  end
end

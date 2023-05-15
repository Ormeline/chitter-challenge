require "test_helper"

describe User do
  before(:each) do
    reset
  end

  describe "all" do
    it "returns an array of all users in the database" do
      users = User.all
      expect(users.length).to eq(3)
      expect(users[0].username).to eq("alice")
      expect(users[0].email).to eq("alice@example.com")
    end

    it "returns an empty array if there are no users in the database" do
      conn = PG.connect(dbname: 'chitter_test', user: 'ormeline')
      conn.exec("TRUNCATE TABLE users RESTART IDENTITY CASCADE")
      conn.close
      users = User.all
      expect(users).to be_empty
    end
  end

  describe "find" do
    it "returns the user with the specified ID" do
      user1 = User.new(username: "user1", email: "user1@example.com", password_digest: "password1")
      user1.save
      user2 = User.new(username: "user2", email: "user2@example.com", password_digest: "password2")
      user2.save
      found_user = User.find(user1.id)
      expect(found_user.username).to eq("user1")
      expect(found_user.email).to eq("user1@example.com")
    end

    it "returns an empty User object if no user with the specified ID exists" do
      found_user = User.find(123)
      expect(found_user).to be_an_instance_of(User)
      expect(found_user.id).to be_nil
      expect(found_user.username).to be_nil
      expect(found_user.email).to be_nil
      expect(found_user.password_digest).to be_nil
    end
  end

  describe "save" do
    it "saves a new user to the database" do
      user = User.new(username: "user1", email: "user1@example.com", password_digest: "password1")
      user.save
      expect(user.id).not_to be_nil
      expect(User.find(user.id).email).to eq("user1@example.com")
    end

    it "updates an existing user in the database" do
      user = User.new(username: "user1", email: "user1@example.com", password_digest: "password1")
      user.save
      user.email = "new_email@example.com"
      user.save
      expect(User.find(user.id).email).to eq("new_email@example.com")
    end
  end

  describe "destroy" do
    it "deletes the user from the database" do
      user = User.new(username: "user1", email: "user1@example.com", password_digest: "password1")
      user.save
      user.destroy
      found_user = User.find(user.id)
      expect(found_user).to be_an_instance_of(User)
      expect(found_user.id).to be_nil
      expect(found_user.username).to be_nil
      expect(found_user.email).to be_nil
      expect(found_user.password_digest).to be_nil
    end
  end

describe "authenticate" do
  it "returns the user if the email and password are correct" do
    user = User.find(1)
    authenticated_user = User.authenticate("alice@example.com", "password")
    expect(authenticated_user).to be_an_instance_of(User)
    expect(authenticated_user.id).to eq(user.id)
    expect(authenticated_user.username).to eq(user.username)
    expect(authenticated_user.email).to eq(user.email)
    expect(authenticated_user.password_digest).to eq(user.password_digest)
  end

  it "returns an empty User object if the email is incorrect" do
    authenticated_user = User.authenticate("alice1@example.com", "password")
    expect(authenticated_user).to be_an_instance_of(User)
    expect(authenticated_user.id).to be_nil
    expect(authenticated_user.username).to be_nil
    expect(authenticated_user.email).to be_nil
    expect(authenticated_user.password_digest).to be_nil
  end

  it "returns an empty User object if the password is incorrect" do
    authenticated_user = User.authenticate("alice@example.com", "password1")
    expect(authenticated_user).to be_an_instance_of(User)
    expect(authenticated_user.id).to be_nil
    expect(authenticated_user.username).to be_nil
    expect(authenticated_user.email).to be_nil
    expect(authenticated_user.password_digest).to be_nil
  end
end
end
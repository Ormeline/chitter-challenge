require "spec_helper"
require "test_helper"
include TestHelper

describe Comment do
  before(:each) do
    reset
  end

  it "can be added in the database" do
    expect(Comment.count).to eq(9)
    peep = Peep.new(content: "Hello, world!", user_id: 1)
    peep.save
    comment1 = Comment.new(message: "Nice peep!", peep_id: peep.id)
    expect(Comment.most_recent.message).to eq("Nice peep!")
  end

  it "can be deleted from the database" do
    expect(Comment.count).to eq(9)
    peep = Peep.new(content: "Hello, world!", user_id: 1)
    peep.save
    comment1 = Comment.new(message: "Nice peep!", peep_id: peep.id)
    comment1.destroy
    expect(Comment.count).to eq(9)
  end

  it "can be updated in the database" do
    comment = Comment.find(1)
    comment.message = "Updated message"
    comment.update
    comment = Comment.find(1)
    expect(comment.message).to eq("Updated message")
  end

  it "is automatically deleted if the peep it belongs to is deleted" do
    expect(Comment.count).to eq(9)

    peep = Peep.new(content: "Hello, world!", user_id: 1)
    peep.save
    comment1 = Comment.new(message: "Nice peep!", peep_id: peep.id)
    comment1.save
    comment2 = Comment.new(message: "I agree!", peep_id: peep.id)
    comment2.save
    expect(Comment.count).to eq(11)
    peep.destroy
    expect(Comment.count).to eq(9)
  end
end

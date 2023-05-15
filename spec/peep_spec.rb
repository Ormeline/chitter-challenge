require "spec_helper"
require "test_helper"
require "date"
include TestHelper

describe Peep do
  before(:each) do
    reset
  end

  it "can be added to the database" do
    expect(Peep.count).to eq(3)
    peep = Peep.new(content: "Hello, world!", user_id: 1)
    peep.save
    expect(Peep.count).to eq(4)
  end

  it "can be deleted from the database" do
    expect(Peep.count).to eq(3)
    peep = Peep.new(content: "Hello, world!", user_id: 1)
    peep.save
    peep.destroy
    expect(Peep.count).to eq(3)
  end

  it "can be updated in the database" do
    peep = Peep.find(1)
    peep.message = "Updated peep"
    peep.date_time = DateTime.now
    peep.save
    expect(Peep.last.message).to eq("Updated peep")
  end
end

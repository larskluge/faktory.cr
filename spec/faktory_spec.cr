require "./spec_helper"

struct Job < Faktory::Job
  arg int : Int32
  arg string : String

  def perform
    "#{int}-#{string}"
  end
end

describe Faktory do
  describe Job do
    it "compiles" do
      true.should eq(true)
    end
  end
end

require "./spec_helper"

module Faktory
  struct DummyJob < Faktory::Job
    arg int : Int32
    arg string : String

    def perform
      "#{int}-#{string}"
    end
  end

  describe Faktory do
    describe Job do
      it "serializes correctly" do
        job = DummyJob.new(int: 42, string: "foo")
        json = JSON.parse(job.serialize)
        json["jid"].as_s.should match(/^\w{24}$/)
        json["jobtype"].should eq "DummyJob"
        json["args"].should eq [42, "foo"]
        json["queue"].should eq "default"
      end
    end
  end
end

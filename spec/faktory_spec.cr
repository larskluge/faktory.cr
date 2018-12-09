require "./spec_helper"

module Faktory
  struct DummyJob < Faktory::Job
    arg int : Int32
    arg string : String
    getter int
    getter string

    def created_at
      @created_at.as(Time)
    end

    def perform
      "#{int}-#{string}"
    end
  end

  describe Faktory do
    describe Job do
      it "serializes" do
        job = DummyJob.new(int: 42, string: "foo")
        json = JSON.parse(job.serialize)
        json["jid"].as_s.should match(/^\w{24}$/)
        json["jobtype"].should eq "DummyJob"
        json["args"].should eq [42, "foo"]
        json["queue"].should eq "default"
      end

      it "deserializes" do
        serialized_job = %q({"jid":"dce7a5302b597732159f36c7","queue":"default","jobtype":"Job","args":[42, "Hello World"],"priority":5,"created_at":"2018-12-09T20:59:19.33795106Z","enqueued_at":"2018-12-09T20:59:19.337963716Z","reserve_for":1800,"retry":25})
        payload = JSON.parse(serialized_job)
        job = DummyJob.deserialize payload
        job.int.should eq 42
        job.string.should eq "Hello World"
        job.created_at.should eq Time::Format::RFC_3339.parse("2018-12-09T20:59:19.33795106Z")
      end
    end
  end
end

require "helper"

describe RsyncCron::Host do
  it "must be factorized by path" do
    host = RsyncCron::Host.factory("/hey/bulldog")
    host.must_be_instance_of RsyncCron::Host
    host.to_s.must_equal "/hey/bulldog"
  end

  it "must be factorized by path, user and ip" do
    host = RsyncCron::Host.factory("john@72.32.11.128:/hey/bulldog")
    host.must_be_instance_of RsyncCron::Host
    host.to_s.must_equal "john@72.32.11.128:/hey/bulldog"
  end

  it "must be represented by path" do
    host = RsyncCron::Host.new(path: "/you/say/goodbye")
    host.to_s.must_equal "/you/say/goodbye"
  end

  it "must be represented by path and remote" do
    host = RsyncCron::Host.new(path: "/yellow/submarine", remote: "YellowSubmarine")
    host.to_s.must_equal "YellowSubmarine:/yellow/submarine"
  end

  it "must check for local path existence" do
    host = RsyncCron::Host.new(path: "~/")
    host.exist?.must_equal true
  end

  it "must check for local path inexistence" do
    host = RsyncCron::Host.new(path: "/noent")
    host.exist?.must_equal false
  end
end

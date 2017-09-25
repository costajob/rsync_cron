require "helper"

describe RsyncCron::Host do
  it "must be represented as a string" do
    host = RsyncCron::Host.new(path: "/yellow/submarine", user: "ringo", ip: "72.32.11.128")
    host.to_s.must_equal "ringo@72.32.11.128:/yellow/submarine"
  end

  it "must omit remote when not specified" do
    host = RsyncCron::Host.new(path: "/you/say/goodbye", user: "paul")
    host.to_s.must_equal "/you/say/goodbye"
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

require "helper"

describe RsyncCron::Options do
  it "must be represented as a string" do
    options = RsyncCron::Options.new
    options.to_s.must_equal "-vrtzp --rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate'"
  end

  it "must omit flags when not specified" do
    options = RsyncCron::Options.new(flags: nil)
    options.to_s.must_equal "--rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate'"
  end

  it "must omit data when not specified" do
    options = RsyncCron::Options.new(data: nil)
    options.to_s.must_equal "-vrtzp"
  end

  it "must merge options to data" do
    options = RsyncCron::Options.new
    options.merge({ "write-batch"=>"'.batch'" })
    options.to_s.must_equal "-vrtzp --rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate' --write-batch='.batch'"
  end
end

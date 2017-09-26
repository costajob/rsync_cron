require "helper"

describe RsyncCron::Options do
  let(:empty) { RsyncCron::Options.new([]) }

  it "must be represented as a string" do
    options = RsyncCron::Options.new
    options.to_s.must_equal "--verbose --archive --compress --rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate'"
  end

  it "must add extra flag" do
    def empty.supported?(name); true; end
    empty << "noatime,write-batch='rsync.bak'"
    empty.to_s.must_equal "--noatime --write-batch='rsync.bak'"
  end

  it "must prevent adding of invalid flag" do
    def empty.supported?(name); false; end
    empty << "invalid"
    empty.to_s.must_be_nil
  end
end

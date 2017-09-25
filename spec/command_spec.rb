require "helper"

describe RsyncCron::Command do
  let(:noent) { RsyncCron::Host.new(path: "/noent") }
  let(:cwd) { RsyncCron::Host.new(path: "./") }
  let(:root) { RsyncCron::Host.new(path: "/") }
  let(:tmp) { RsyncCron::Host.new(path: "/tmp") }

  it "must exit early if source does not exist" do
    rsync = RsyncCron::Command.new(source: noent, target: cwd)
    rsync.call.must_be_nil
  end

  it "must exit early if target does not exist" do
    rsync = RsyncCron::Command.new(source: cwd, target: noent)
    rsync.call.must_be_nil
  end

  it "must warn if program does not exist" do
    rsync = RsyncCron::Command.new(source: cwd, target: root, name: "")
    rsync.to_s.must_equal "echo 'rsync not installed'"
  end

  it "must build the command properly" do
    rsync = RsyncCron::Command.new(source: root, target: tmp)
    rsync.to_s.must_equal "/usr/bin/rsync -vrtzp --rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate' / /tmp"
  end
end

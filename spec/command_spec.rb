require "helper"

describe RsyncCron::Command do
  let(:noent) { RsyncCron::Host.new(path: "/noent") }
  let(:root) { RsyncCron::Host.new(path: "/") }
  let(:remote) { RsyncCron::Host.new(path: "/yellow/submarine", user: "ringo", ip: "72.32.11.128") }

  it "must be invalid if src does not exist" do
    rsync = RsyncCron::Command.new(src: noent, dest: root)
    rsync.valid?.must_equal false
  end

  it "must be invalid if dest does not exist" do
    rsync = RsyncCron::Command.new(src: root, dest: noent)
    rsync.valid?.must_equal false
  end

  it "must warn if program does not exist" do
    rsync = RsyncCron::Command.new(src: root, dest: remote, name: "")
    rsync.to_s.must_equal "echo 'rsync not installed'"
  end

  it "must build the command properly" do
    rsync = RsyncCron::Command.new(src: root, dest: remote)
    rsync.to_s.must_equal "/usr/bin/rsync -vrtzp --rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate' / ringo@72.32.11.128:/yellow/submarine"
  end

  it "must accept a log file" do
    rsync = RsyncCron::Command.new(src: root, dest: remote, log: "/var/log/rsync.log")
    rsync.to_s.must_equal "/usr/bin/rsync -vrtzp --rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate' --log-file=/var/log/rsync.log / ringo@72.32.11.128:/yellow/submarine"
  end
end

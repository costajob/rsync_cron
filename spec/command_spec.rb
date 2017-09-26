require "helper"

describe RsyncCron::Command do
  let(:io) { StringIO.new }
  let(:noent) { RsyncCron::Host.new(path: "/noent") }
  let(:root) { RsyncCron::Host.new(path: "/") }
  let(:remote) { RsyncCron::Host.new(path: "/yellow/submarine", remote: "ringo@72.32.11.128") }

  it "must be invalid if src does not exist" do
    rsync = RsyncCron::Command.new(src: noent, dest: root, io: io)
    rsync.valid?.must_equal false
  end

  it "must be invalid if dest does not exist" do
    rsync = RsyncCron::Command.new(src: root, dest: noent, io: io)
    rsync.valid?.must_equal false
  end

  it "must warn if program does not exist" do
    rsync = RsyncCron::Command.new(src: root, dest: remote, name: "", io: io)
    rsync.to_s.must_equal "echo 'rsync not installed'"
  end

  it "must build the command properly" do
    rsync = RsyncCron::Command.new(src: root, dest: remote, io: io)
    rsync.to_s.must_equal "/usr/bin/rsync --noatime --verbose --archive --compress --rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate' / ringo@72.32.11.128:/yellow/submarine"
  end

  it "must accept a log file" do
    rsync = RsyncCron::Command.new(src: root, dest: remote, log: "/var/log/rsync.log", io: io)
    rsync.to_s.must_equal "/usr/bin/rsync --noatime --verbose --archive --compress --rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate' / ringo@72.32.11.128:/yellow/submarine >> /var/log/rsync.log 2>&1"
  end
end

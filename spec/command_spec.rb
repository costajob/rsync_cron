require "helper"

describe RsyncCron::Command do
  let(:io) { StringIO.new }
  let(:options) { RsyncCron::Options.new("archive") }
  let(:noent) { RsyncCron::Host.new(path: "/noent") }
  let(:root) { RsyncCron::Host.new(path: "/") }
  let(:remote) { RsyncCron::Host.new(path: "/yellow/submarine", remote: "ringo@72.32.11.128") }

  it "must be invalid if src does not exist" do
    command = RsyncCron::Command.new(src: noent, dest: root, io: io)
    command.valid?.must_equal false
    io.string.must_equal "/noent does not exist\n"
  end

  it "must be invalid if dest does not exist" do
    command = RsyncCron::Command.new(src: root, dest: noent, io: io)
    command.valid?.must_equal false
    io.string.must_equal "/noent does not exist\n"
  end

  it "must warn if program does not exist" do
    command = RsyncCron::Command.new(src: root, dest: remote, name: "", io: io)
    command.to_s.must_be_nil
    io.string.must_equal "rsync not installed\n"
  end

  it "must build the command properly" do
    command = RsyncCron::Command.new(src: root, dest: remote, options: options, io: io)
    command.to_s.must_equal "/usr/bin/rsync --archive / ringo@72.32.11.128:/yellow/submarine"
  end

  it "must accept a log file" do
    command = RsyncCron::Command.new(src: root, dest: remote, options: options, log: "/var/log/rsync.log", io: io)
    command.to_s.must_equal "/usr/bin/rsync --archive / ringo@72.32.11.128:/yellow/submarine >> /var/log/rsync.log 2>&1"
  end
end

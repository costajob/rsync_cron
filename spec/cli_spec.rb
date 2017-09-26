require "helper"

describe RsyncCron::CLI do
  let(:io) { StringIO.new }
  let(:temp) { Tempfile.new("foo") }
  let(:log) { Tempfile.new(["rsync", ".log"]) }
  let(:shell) { "cat > #{temp.path}" }
  let(:cron) { "15,30,45 * * * *" }

  it "must install command with default cron" do
    cli = RsyncCron::CLI.new(["--src=/", "--dest=/tmp"], io, shell)
    cli.call.must_equal true
    io.string.must_equal "new crontab installed\n"
    temp.read.must_equal "* 0 * * * /usr/bin/rsync --verbose --archive --compress --rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate' / /tmp\n"
  end

  it "must install command with specified cron" do
    cli = RsyncCron::CLI.new(["--cron=#{cron}", "--src=/", "--dest=/tmp"], io, shell)
    cli.call.must_equal true
    temp.read.must_equal "15,30,45 * * * * /usr/bin/rsync --verbose --archive --compress --rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate' / /tmp\n"
  end

  it "must install command and log to specified file" do
    cli = RsyncCron::CLI.new(["--cron=#{cron}", "--src=/", "--dest=/tmp", "--log=#{log.path}"], io, shell)
    cli.call.must_equal true
    temp.read.must_equal "15,30,45 * * * * /usr/bin/rsync --verbose --archive --compress --rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate' / /tmp >> #{log.path} 2>&1\n"
  end

  it "must install command with specified options" do
    cli = RsyncCron::CLI.new(["--cron=#{cron}", "--src=/", "--dest=/tmp", "--opts=noatime,ipv4,log-file='./rsync.log'"], io, shell)
    opts = cli.options
    def opts.supported?(name); true; end
    cli.call.must_equal true
    temp.read.must_equal "15,30,45 * * * * /usr/bin/rsync --verbose --archive --compress --rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate' --noatime --ipv4 --log-file='./rsync.log' / /tmp\n"
  end

  it "must return early for missing src" do
    cli = RsyncCron::CLI.new(["--cron=#{cron}", "--dest=/tmp"], io, shell)
    cli.call.must_be_nil
    io.string.must_equal "specify valid src\n"
    temp.read.must_be_empty
  end

  it "must return early for missing dest" do
    cli = RsyncCron::CLI.new(["--cron=#{cron}", "--src=/"], io, shell)
    cli.call.must_be_nil
    io.string.must_equal "specify valid dest\n"
    temp.read.must_be_empty
  end

  it "must check src and dest when specified" do
    cli = RsyncCron::CLI.new(["--check", "--cron=#{cron}", "--src=/", "--dest=/noent"], io, shell)
    cli.call.must_be_nil
    temp.read.must_be_empty
  end

  it "must print command to specified output" do
    cli = RsyncCron::CLI.new(["--cron=#{cron}", "--src=/", "--dest=/tmp", "--log=#{log.path}", "--print"], io, shell)
    cli.call.must_be_nil
    io.string.must_equal "15,30,45 * * * * /usr/bin/rsync --verbose --archive --compress --rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate' / /tmp >> #{log.path} 2>&1\n"
  end

  it "must print the help" do
    begin
      RsyncCron::CLI.new(%w[--help], io).call
    rescue SystemExit
      io.string.must_equal "Usage: rsync_cron --cron='15,30 21' --src=/ --dest=/tmp --log=/var/log/rsync.log --opts=noatime,temp-dir='./temp'\n    -c, --cron=CRON                  The cron string, i.e.: '15 21 * * *'\n    -s, --src=SRC                    The rsync source, i.e. user@src.com:files\n    -d, --dest=DEST                  The rsync dest, i.e. user@dest.com:home/\n    -l, --log=LOG                    log command output to specified file\n    -o, --opts=OPTS                  merge specified extra options\n    -p, --print                      Print crontab command without installing it\n    -k, --check                      Check src and dest before installing crontab\n    -h, --help                       Prints this help\n"
    end
  end
end

require "helper"

describe RsyncCron::CLI do
  let(:io) { StringIO.new }
  let(:temp) { Tempfile.new("foo") }
  let(:log) { Tempfile.new(["rsync", ".log"]) }
  let(:shell) { "cat > #{temp.path}" }
  let(:cron) { "15,30,45 * * * *" }

  it "must write rsync command with default cron" do
    cli = RsyncCron::CLI.new(["--src=/", "--dest=/tmp"], io)
    cli.call(shell).must_equal true
    io.string.must_equal "crontab written\n"
    temp.read.must_equal "* 0 * * * /usr/bin/rsync -vrtzp --rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate' / /tmp"
  end

  it "must write rsync command with specified cron" do
    cli = RsyncCron::CLI.new(["--cron=#{cron}", "--src=/", "--dest=/tmp"], io)
    cli.call(shell).must_equal true
    io.string.must_equal "crontab written\n"
    temp.read.must_equal "15,30,45 * * * * /usr/bin/rsync -vrtzp --rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate' / /tmp"
  end

  it "must write rscyn command and log to specified file" do
    cli = RsyncCron::CLI.new(["--cron=#{cron}", "--src=/", "--dest=/tmp", "--log=#{log.path}"], io)
    cli.call(shell).must_equal true
    io.string.must_equal "crontab written\n"
    temp.read.must_equal "15,30,45 * * * * /usr/bin/rsync -vrtzp --rsh=ssh --bwlimit=5120 --exclude='DfsrPrivate' / /tmp >> #{log.path} 2>&1"
  end

  it "must return early for missing src" do
    cli = RsyncCron::CLI.new(["--cron=#{cron}", "--dest=/tmp"], io)
    cli.call(shell).must_be_nil
    io.string.must_be_empty
    temp.read.must_be_empty
  end

  it "must return early for missing dest" do
    cli = RsyncCron::CLI.new(["--cron=#{cron}", "--src=/"], io)
    cli.call(shell).must_be_nil
    io.string.must_be_empty
    temp.read.must_be_empty
  end

  it "must return early for missing command" do
    cli = RsyncCron::CLI.new(["--cron=#{cron}", "--src=/", "--dest=~/noent"], io)
    cli.call(shell).must_be_nil
    io.string.must_be_empty
    temp.read.must_be_empty
  end

  it "must print the help" do
    begin
      RsyncCron::CLI.new(%w[--help], io).call
    rescue SystemExit
      io.string.must_equal "Usage: rsync_cron --cron=15,30 21 * * * --src=/ --dest=/tmp --log=/var/log/rsync.log\n    -c, --cron=CRON                  The cron string, i.e.: 15 21 * * *\n    -s, --src=SRC                    The rsync source, i.e. user@src.com:files\n    -d, --dest=DEST                  The rsync dest, i.e. user@dest.com:home/\n    -l, --log=LOG                    log command output to specified file\n    -h, --help                       Prints this help\n"
    end
  end
end

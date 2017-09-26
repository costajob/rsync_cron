require "optparse"
require "rsync_cron/host"
require "rsync_cron/command"
require "rsync_cron/installer"
require "rsync_cron/cron"

module RsyncCron
  class CLI
    SHELL = `which crontab`.strip

    def initialize(args, io = STDOUT, shell = SHELL)
      @args = args
      @io = io
      @cron = Cron.factory("* 0 * * *")
      @shell = shell
    end

    def call
      parser.parse!(@args)
      return @io.puts "specify valid src" unless @src
      return @io.puts "specify valid dest" unless @dest
      command = Command.new(src: @src, dest: @dest, log: @log, io: @io)
      return unless command.valid? if @check
      crontab = "#{@cron} #{command}"
      return @io.puts crontab unless @shell
      Installer.new(crontab, @shell).call.tap do |res|
        @io.puts "new crontab installed" if res
      end
    end

    private def parser
      OptionParser.new do |opts|
        opts.banner = "Usage: rsync_cron --cron=15,30 21 * * * --src=/ --dest=/tmp --log=/var/log/rsync.log"

        opts.on("-cCRON", "--cron=CRON", "The cron string, i.e.: 15 21 * * *") do |cron|
          @cron = Cron.factory(cron)
        end

        opts.on("-sSRC", "--src=SRC", "The rsync source, i.e. user@src.com:files") do |src|
          @src = Host.factory(src)
        end

        opts.on("-dDEST", "--dest=DEST", "The rsync dest, i.e. user@dest.com:home/") do |dest|
          @dest = Host.factory(dest)
        end

        opts.on("-lLOG", "--log=LOG", "log command output to specified file") do |log|
          @log = log
        end

        opts.on("-p", "--print", "Print crontab command without installing it") do
          @shell = nil
        end

        opts.on("-k", "--check", "Check src and dest before installing crontab") do
          @check = true
        end

        opts.on("-h", "--help", "Prints this help") do
          @io.puts opts
          exit
        end
      end
    end
  end
end


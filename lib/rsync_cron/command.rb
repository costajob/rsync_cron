require "rsync_cron/options"

module RsyncCron
  class Command
    NAME = `which rsync`.strip

    def initialize(src:, dest:, options: Options.new, name: NAME, log: nil, io: STDOUT)
      @src = src
      @dest = dest
      @options = options
      @name = name
      @log = log
      @io = io
    end

    def to_s
      return "echo 'rsync not installed'" if @name.empty?
      "#{@name} #{@options} #{@src} #{@dest}#{log}"
    end

    def valid?
      [@src, @dest].all? do |host|
        host.exist?.tap do |check|
          @io.puts "#{host} does not exist" unless check
        end
      end
    end

    private def log
      return unless @log
      " >> #{File.expand_path(@log)} 2>&1"
    end
  end
end

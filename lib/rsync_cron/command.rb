require "rsync_cron/options"

module RsyncCron
  class Command
    NAME = `which rsync`.strip

    def initialize(src:, dest:, options: Options.new, name: NAME, log: nil)
      @src = src
      @dest = dest
      @options = options
      @name = name
      @log = log
    end

    def to_s
      return "echo 'rsync not installed'" if @name.empty?
      "#{@name} #{@options} #{@src} #{@dest}#{log}"
    end

    def valid?
      @src.exist? && @dest.exist?
    end

    private def log
      return unless @log
      " >> #{@log} 2>&1"
    end
  end
end

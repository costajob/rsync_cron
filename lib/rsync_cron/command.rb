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
      "#{@name} #{options} #{@src} #{@dest}"
    end

    def valid?
      @src.exist? && @dest.exist?
    end

    private def options
      return @options unless @log
      @options.merge("log-file"=>@log)
    end
  end
end

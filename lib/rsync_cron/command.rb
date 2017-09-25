require "benchmark"
require "logger"
require "rsync_cron/host"
require "rsync_cron/options"

module RsyncCron
  class Command
    NAME = `which rsync`.strip

    def initialize(source:, target:, options: Options.new, logger: Logger.new(nil), name: NAME)
      @source = source
      @target = target
      @options = options
      @logger = logger
      @name = name
    end

    def call
      return unless @source.exist? && @target.exist?
      @logger.info { "rsync from #{@source} to #{@target}" }
      t = Benchmark.measure do
        %x[#{self} 2>&1].tap do |output|
          @logger.debug { output }
        end
      end
      yield t if block_given?
      @logger.info { "rsync completed in #{t.real.round(4)} seconds" }
    end

    def to_s
      return "echo 'rsync not installed'" if @name.empty?
      "#{@name} #{@options} #{@source} #{@target}"
    end
  end
end

module RsyncCron
  class Options
    BANDWITH_LIMIT = 5*1024
    DEFAULT = { 
      rsh: "ssh",
      bwlimit: BANDWITH_LIMIT,
      exclude: "'DfsrPrivate'"
    }
    FLAGS = %w[noatime verbose archive compress]

    def initialize(data: DEFAULT, flags: FLAGS)
      @data = data.to_h
      @flags = flags.to_a
    end

    def to_s
      [flags, data].compact.join(" ")
    end

    def merge(opt)
      @data = @data.merge(opt)
      self
    end

    private def flags
      return if @flags.empty?
      @flags.map { |flag| "--#{flag}" }.join(" ")
    end

    private def data
      return if @data.empty?
      @data.reduce([]) do |acc, (opt, val)|
        acc << "--#{opt}=#{val}"
      end.join(" ")
    end
  end
end


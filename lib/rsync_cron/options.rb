module RsyncCron
  class Options
    BANDWITH_LIMIT = 5*1024
    DEFAULT = { 
      rsh: "ssh",
      bwlimit: BANDWITH_LIMIT,
      exclude: "'DfsrPrivate'"
    }
    FLAGS = %w[v r t z p]

    def initialize(data: DEFAULT, flags: FLAGS, extra: {})
      @data = data.to_h.merge(extra)
      @flags = flags.to_a
    end

    def to_s
      [flags, data].compact.join(" ")
    end

    private def flags
      return if @flags.empty?
      "-#{@flags.join}"
    end

    def data
      return if @data.empty?
      @data.reduce([]) do |acc, (opt, val)|
        acc << "--#{opt}=#{val}"
      end.join(" ")
    end
  end
end


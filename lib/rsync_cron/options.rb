module RsyncCron
  class Options
    BW_LIMIT = 5*1024
    DEFAULT_FLAGS = %W[verbose archive compress rsh=ssh bwlimit=#{BW_LIMIT} exclude='DfsrPrivate']

    def initialize(flags = DEFAULT_FLAGS)
      @flags = Array(flags.dup)
    end

    def to_s
      return if @flags.empty?
      @flags.map { |flag| "--#{flag}" }.join(" ")
    end

    def <<(flags)
      flags.split(",").each do |flag|
        @flags << flag if supported?(flag)
      end
      self
    end

    private def supported?(flag)
      %x[rsync --#{flag} 2>&1].match(/unknown option/).nil?
    end
  end
end


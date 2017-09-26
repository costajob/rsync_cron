module RsyncCron
  class Host
    def self.factory(s)
      return new(path: s) unless s.index(":")
      remote, path = s.split(":")
      new(path: path, remote: remote)
    end

    def initialize(path:, remote: nil)
      @path = path
      @remote = remote
    end

    def to_s
      [remote, path].compact.join(":")
    end

    def exist?
      return FileTest.exist?(path) unless remote?
      %x[ssh #{remote} "test -e #{path}"]
      $?.exitstatus.zero?
    end

    private def path
      return @path if remote?
      File.expand_path(@path)
    end

    private def remote
      return unless remote?
      @remote
    end

    private def remote?
      @remote
    end
  end
end

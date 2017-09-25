module RsyncCron
  class Host
    def self.factory(s)
      return new(path: s) unless s.index(":")
      remote, path = s.split(":")
      user, ip = remote.split("@")
      new(path: path, user: user, ip: ip)
    end

    def initialize(path:, user: nil, ip: nil)
      @path = path
      @user = user
      @ip = ip
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
      "#{@user}@#{@ip}"
    end

    private def remote?
      @user && @ip
    end
  end
end

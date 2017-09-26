module RsyncCron
  class Scheduler
    def initialize(content, shell)
      @content = content
      @shell = shell
    end

    def call
      return if @shell.empty?
      IO.popen(@shell, "a+") do |pipe|
        pipe.puts(@content)
        pipe.close_write
      end
      $?.exitstatus.zero?
    end
  end
end

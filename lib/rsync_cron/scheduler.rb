module RsyncCron
  class Scheduler
    def initialize(content, shell)
      @content = content
      @shell = shell
    end

    def call
      return if @shell.empty?
      IO.popen(@shell, 'r+') do |io|
        io.write(@content)
        io.close_write
      end
      $?.exitstatus.zero?
    end
  end
end

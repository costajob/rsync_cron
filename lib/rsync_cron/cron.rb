module RsyncCron
  class Cron
    ANY = "*"

    def self.factory(s)
      mins, hour, day, month, week = s.split(" ")
      mins = mins.split(",")
      new(mins: mins, hour: hour, day: day, month: month, week: week)
    end

    def initialize(mins: nil, hour: nil, day: nil, month: nil, week: nil)
      @mins = mins.to_a
      @hour = hour
      @day = day
      @month = month
      @week = week
    end

    def to_s
      "#{mins} #{hour} #{day} #{month} #{week}"
    end

    private def mins
      return ANY if @mins.empty?
      return ANY unless @mins.all? { |min| (0..59) === min.to_i }
      @mins.join(",")
    end

    private def hour
      return ANY if @hour == ANY || @hour.nil?
      return ANY unless (0..23) === @hour.to_i
      @hour
    end

    private def day
      return ANY unless (1..31) === @day.to_i
      @day
    end

    private def month
      return ANY unless (1..12) === @month.to_i
      @month
    end

    private def week
      return ANY if @week == ANY || @week.nil?
      return ANY unless (0..7) === @week.to_i
      @week
    end
  end
end

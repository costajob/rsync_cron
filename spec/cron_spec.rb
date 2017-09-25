require "helper"

describe RsyncCron::Cron do
  it "must be factorized by string" do
    cron = RsyncCron::Cron.factory("17,34 33 29 10 8")
    cron.must_be_instance_of(RsyncCron::Cron)
    cron.to_s.must_equal "17,34 * 29 10 *"
  end

  it "must intercept just first digits" do
    cron = RsyncCron::Cron.factory("0,15,30,45")
    cron.must_be_instance_of(RsyncCron::Cron)
    cron.to_s.must_equal "0,15,30,45 * * * *"
  end

  it "must default to anytime" do
    cron = RsyncCron::Cron.new
    cron.to_s.must_equal "* * * * *"
  end

  it "must accept multiple minutes" do
    cron = RsyncCron::Cron.new(mins: [15,30,45])
    cron.to_s.must_equal "15,30,45 * * * *"
  end

  it "must default to anytime for invalid minutes" do
    cron = RsyncCron::Cron.new(mins: [150,30,45])
    cron.to_s.must_equal "* * * * *"
  end

  it "must accept hour within 0 and 23" do
    cron = RsyncCron::Cron.new(hour: "22")
    cron.to_s.must_equal "* 22 * * *"
  end

  it "must default to anytime for invalid hour" do
    cron = RsyncCron::Cron.new(hour: 30)
    cron.to_s.must_equal "* * * * *"
  end

  it "must accept any hour" do
    cron = RsyncCron::Cron.new(hour: "*")
    cron.to_s.must_equal "* * * * *"
  end

  it "must accept day within 1 and 31" do
    cron = RsyncCron::Cron.new(day: 30)
    cron.to_s.must_equal "* * 30 * *"
  end

  it "must default to anytime for invalid day" do
    cron = RsyncCron::Cron.new(day: "35")
    cron.to_s.must_equal "* * * * *"
  end

  it "must accept month within 1 and 12" do
    cron = RsyncCron::Cron.new(month: "10")
    cron.to_s.must_equal "* * * 10 *"
  end

  it "must default to anytime for invalid month" do
    cron = RsyncCron::Cron.new(month: 15)
    cron.to_s.must_equal "* * * * *"
  end

  it "must accept week within 0 and 6" do
    cron = RsyncCron::Cron.new(week: "4")
    cron.to_s.must_equal "* * * * 4"
  end

  it "must default to anytime for invalid week" do
    cron = RsyncCron::Cron.new(week: 8)
    cron.to_s.must_equal "* * * * *"
  end

  it "must accept any week" do
    cron = RsyncCron::Cron.new(week: "*")
    cron.to_s.must_equal "* * * * *"
  end

  it "must combine values" do
    cron = RsyncCron::Cron.new(mins: [17,34], hour: 21, day: 29, month: 10, week: "*")
    cron.to_s.must_equal "17,34 21 29 10 *"
  end
end

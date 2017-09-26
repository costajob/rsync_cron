require "helper"

describe RsyncCron::Scheduler do
  let(:content) { "0,15,30,45 * * * * rm /home/someuser/tmp/*" }

  it "must return early when program does not exist" do
    scheduler = RsyncCron::Scheduler.new(content, "")
    scheduler.call.must_be_nil
  end

  it "must write to soecified IO" do
    temp = Tempfile.new("foo")
    scheduler = RsyncCron::Scheduler.new(content, "cat > #{temp.path}")
    scheduler.call
    temp.read.must_equal "#{content}\n"
  end
end

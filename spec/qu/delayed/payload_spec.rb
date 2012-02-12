require 'spec_helper'
require 'timecop'
require 'mongo'

describe Qu::Delayed::Payload do
  before do
    Timecop.freeze(Time.now)
  end

  after do
    Timecop.return
  end



  subject { Qu::Delayed::Payload.new(:klass => SimpleJob, :run_at => Time.now, :args => [8,9]) }

  it 'should enqueue it to normal queue' do
    Qu.should_receive(:enqueue).with(SimpleJob, [8,9])
    subject.perform
  end

  it 'should overload to_s' do
    subject.id = BSON::ObjectId.new
    subject.to_s.should == "#{Time.now.to_i}:#{subject.id}:#{subject.klass}:#{subject.args.inspect}"
  end


end

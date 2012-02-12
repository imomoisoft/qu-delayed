require 'spec_helper'

require 'qu-delayed-mongo'

describe Qu::Backend::Mongo do
  before do
    ENV.delete('MONGOHQ_URL')
    subject.logger.level = 3
    subject.clear
    subject.clear_delayed
  end

  let(:payload) { Qu::Delayed::Payload.new(:run_at => Time.now + 5 * 60, :klass => SimpleJob, :args => [8,9]) }

  before(:all) do
    Qu.backend = described_class.new
  end

  context 'should be extended with Qu::Backend::Delayed::Mongo' do
    it '#enqueue_at' do
      subject.should respond_to(:enqueue_at)
    end
  end

  describe 'enqueued job' do
    before { subject.enqueue_at(payload) }
    let(:delayed_payload) { Qu::Delayed::Payload.new(subject.delayed_jobs.find_one) }

    it 'should have run_at field deserialized from _id' do
      delayed_payload.run_at.to_i.should == payload.run_at.to_i
    end

    it 'should have klass value deserialized' do
      delayed_payload.klass.should == payload.klass
    end

    it 'should have args value deserialized' do
      delayed_payload.args.should == payload.args
    end
  end

  describe 'sheduler' do
    it 'should enqueue job when time comes' do
      payload.run_at = Time.now - 5*60
      subject.should_receive(:enqueue)
      subject.enqueue_at(payload)
      subject.next_delayed_job
      subject.delayed_jobs.count.should == 0
    end

    it 'should enqueue job when time in the future' do
      payload.run_at = Time.now + 5*60
      subject.should_not_receive(:enqueue)
      subject.enqueue_at(payload)
      subject.next_delayed_job
      subject.delayed_jobs.count.should == 1
    end
  end
end

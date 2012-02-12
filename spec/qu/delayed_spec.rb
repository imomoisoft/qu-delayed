require 'spec_helper'

describe Qu::Delayed do
  context 'should extend Qu with' do
    it 'enqueue_at' do
      Qu.should respond_to(:enqueue_at)
    end

    it 'enqueue_in' do
      Qu.should respond_to(:enqueue_in)
    end
  end

  describe '#enqueue_at' do
    it 'should send correct message to backend' do
      run_at = Time.now
      Qu.backend.should_receive(:enqueue_at) do |payload|
        payload.should be_instance_of(Qu::Delayed::Payload)
        payload.klass.should == SimpleJob
        payload.args.should == [9,8]
        payload.run_at = run_at
      end

      Qu.enqueue_at run_at, SimpleJob, 9, 8
    end
  end

  describe '#enqueue_in' do
    before {Timecop.freeze(Time.now)}
    after {Timecop.return}

    it 'should send correct message to backend' do
      Qu.backend.should_receive(:enqueue_at) do |payload|
        payload.should be_instance_of(Qu::Delayed::Payload)
        payload.klass.should == SimpleJob
        payload.args.should == [9,8]
        payload.run_at = Time.now + 5*60
      end

      Qu.enqueue_in 5*60, SimpleJob, 9, 8
    end
  end

end

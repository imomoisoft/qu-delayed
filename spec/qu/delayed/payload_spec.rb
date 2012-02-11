require 'spec_helper'

describe Qu::Delayed::Payload do
  subject { Qu::Delayed::Payload.new(:klass => SimpleJob, :run_at => Time.now, :args => [8,9]) }

  it 'should enqueue it to normal queue' do
    Qu.should_receive(:enqueue).with(SimpleJob, [8,9])
    subject.perform
  end
end

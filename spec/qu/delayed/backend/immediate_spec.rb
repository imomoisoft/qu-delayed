require 'spec_helper'

require 'qu-delayed-immediate'

describe Qu::Backend::Immediate do
  let(:payload) { Qu::Delayed::Payload.new(:klass => SimpleJob) }

  before(:all) do
    Qu.backend = described_class.new
  end

  context 'should be extended with Qu::Backend::Delayed::Immediate' do
    it '#enqueue_at' do
      subject.should respond_to(:enqueue_at)
    end

    it '#clear_delayed' do
      subject.should respond_to(:clear_delayed)
    end
  end

  it 'performs immediately' do
    payload.should_receive(:perform)
    subject.enqueue_at(payload)
  end

end

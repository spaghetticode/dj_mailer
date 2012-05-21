require 'spec_helper'

module DjMailer
  describe Delayable do
    describe 'the extended class' do
      subject {Class.new {extend Delayable}}

      it 'responds to method_missing_with_delay' do
        subject.should respond_to(:method_missing_with_delay)
      end

      describe 'method_missing_with_delay' do
        context 'when the class does not respond to the method' do
          it 'delegates to the original method_missing' do
            subject.should_receive(:method_missing_without_delay)
            subject.method_missing_with_delay(:not_responding)
          end
        end

        context 'when the class respond to the method' do
          before {subject.should_receive(:respond_to?).and_return(true)}

          context 'when the caller is delayed_job' do
            it 'should delegate to the original method_missing' do
              subject.stub(:caller => ['delayed_job'])
              subject.should_receive(:method_missing_without_delay)
              subject.method_missing_with_delay(:responding)
            end
          end

          context 'when the caller is not delayed_job' do
            it 'should equeue the email for late delivery' do
              subject.stub(:caller => [])
              subject.should_receive(:enqueue_with_delayed_job)
              subject.method_missing_with_delay(:responding)
            end
          end
        end
      end
    end
  end
end

require 'action_mailer'
# cucumber complains with require 'dj_mailer/version'
require File.expand_path('../dj_mailer/version', __FILE__)

module DjMailer
  module Delayable
    module Deliverable
      def deliver; self; end
    end

    def self.extended(base)
      class << base
        alias_method_chain :method_missing, :delay
      end
    end

    def method_missing_with_delay(method, *args)
      if respond_to?(method) and !caller.grep(/delayed_job/).present?
        enqueue_with_delayed_job(method, *args)
      else
        method_missing_without_delay(method, *args)
      end
    end

    def enqueue_with_delayed_job(method, *args)
      delay.send(method, *args).tap do |dj_instance|
        dj_instance.extend Deliverable
      end
    end
  end
end

ActionMailer::Base.extend DjMailer::Delayable

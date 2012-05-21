# At the moment delayed_job_active_record is quite broken. It surely works
# fine with actionmailer 3.0.5
gem 'actionmailer', '3.0.5'
require 'action_mailer'

ActionMailer::Base.delivery_method = :test


# Forcing actionmailer to v3.0.5 requires also activerecord to have same version,
# this is to avoid dependencies conflicts (activesupport version, for example)
gem 'activerecord', '3.0.5'
require 'delayed_job_active_record'

class DjMigration < ActiveRecord::Migration
  def self.up
    create_table :delayed_jobs, :force => true do |table|
      table.integer  :priority, :default => 0      # Allows some jobs to jump to the front of the queue
      table.integer  :attempts, :default => 0      # Provides for retries, but still fail eventually.
      table.text     :handler                      # YAML-encoded string of the object that will do work
      table.text     :last_error                   # reason for last failure (See Note below)
      table.datetime :run_at                       # When to run. Could be Time.zone.now for immediately, or sometime in the future.
      table.datetime :locked_at                    # Set when a client is working on this object
      table.datetime :failed_at                    # Set when all retries have failed (actually, by default, the record is deleted instead)
      table.string   :locked_by                    # Who is working on this object (if locked)
      table.string   :queue                        # The name of the queue this job is in
      table.timestamps
    end

    add_index :delayed_jobs, [:priority, :run_at], :name => 'delayed_jobs_priority'
  end

  def self.down
    drop_table :delayed_jobs
  end
end

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.logger = Logger.new(StringIO.new)
DjMigration.up


require File.expand_path('../../../lib/dj_mailer', __FILE__)

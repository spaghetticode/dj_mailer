# DjMailer

[![Build Status](https://secure.travis-ci.org/spaghetticode/dj_mailer.png)](http://travis-ci.org/spaghetticode/dj_mailer)

This gem allows you to send emails asyncronously via delayed_job_active_record
without modifying the existing codebase, keeping the standard action mailer
interface.

Currenlty delayed_job_active_record requires that you replace all your email
deliver calls as follows:

```ruby
  # without delayed job
  Notifier.signup(@user).deliver

  # with delayed job
  Notifier.delay.signup(@user)
```

By adding this gem in your gemfile all your current emails will be automatically
handled by delayed job without any interface change. At the moment you have
to setup the delayed job environment (running the migrations for the db) on your
own.


## Note

I could not make the current version of delayed_job_active_record (0.3.2) work
with recent versions of ActionMailer, it does with 3.0.5. I will investigate
the reason of the failure ASAP.


## Installation

Add this line to your application's Gemfile:
```ruby
  gem 'dj_mailer'
```
And then execute: `$ bundle`

Or install it yourself as:
```
  $ gem install dj_mailer
```


## Sample delay job migration

Just a reminder I have to add the generator (via rails you can simply run `rails generate delayed_job:active_record)`

```ruby
class CreateDelayedJobs < ActiveRecord::Migration
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
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add your feature tests to the rspec/cucumber test suite
4. Commit your changes (`git commit -am 'Added some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

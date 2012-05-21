Given /^I have the following action mailer class:$/ do |class_definition|
  context_module.class_eval(class_definition)
end

When /^I try to send a test email with the following code:$/ do |code|
  self.result = context_module.class_eval(code)
end

Then /^a delayed job object should be returned$/ do
  result.should be_a(Delayed::Backend::ActiveRecord::Job)
end

Then /^I should see a new delayed_job record in the table$/ do
  Delayed::Job.count.should == 1
end

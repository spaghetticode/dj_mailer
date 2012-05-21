Feature: deliver email asyncronously with delayed_job in a transparent way
In order to add asyncronous email delivery without modifing the existing codebase
As an action mailer 3 and delayed_job user
I want to deliver email asyncronously without modifying existing code

  This is the current delayed job recommended syntax to run asyncronous
  email delivers:
    without delayed_job: Notifier.signup(@user).deliver
    with delayed_job:    Notifier.delay.signup(@user)
  The syntax is quite different, so if you have a big codebase that doesn't use
  yet delayed job it could become rather nasty to replace all the deliver calls.
  This gem allows you to keep the old interface and still get the delayed job
  asyncronous functionality.

Scenario: Email is enqueued successfully
  Given I have the following action mailer class:
    """
    class TestMailer < ActionMailer::Base
      def test(recipient)
        mail to: recipient, from: 'test@test.com', subject: 'asyncronous email'
      end
    end
    """
  When I try to send a test email with the following code:
    """
    TestMailer.test('sender@test.com')
    """
  Then a delayed job object should be returned
  And I should see a new delayed_job record in the table

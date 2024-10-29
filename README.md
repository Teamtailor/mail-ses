[![Gem Version](https://badge.fury.io/rb/mail-ses.svg)](http://badge.fury.io/rb/mail-ses)
[![Github Actions](https://github.com/teamtailor/mail-ses/actions/workflows/test.yml/badge.svg)](https://github.com/teamtailor/mail-ses/actions/workflows/test.yml)

# Mail::SES

## Fork from [tablecheck/mail-ses](https://github.com/tablecheck/mail-ses)
This gem was forked to add support for different message_id domains for different AWS SES regions and support options via message headers.

Mail::SES is a mail delivery method handler for Amazon SES (Simple Email Service) which can be used with Rails' [Action Mailer](https://guides.rubyonrails.org/action_mailer_basics.html).

This gem is inspired by [Drew Blas' AWS::SES gem](https://github.com/drewblas/aws-ses),
but uses the official [AWS SDK for Ruby v3 - SESv2](https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/SESV2.html) under-the-hood.
By passing parameters through to the SDK, this gem supports greater flexibility with less code (including IAM instance profiles, retry parameters, etc.)

### Compatibility

* Ruby 2.6+
* Ruby on Rails 3.2+
* Mail gem 2.8.1+
* AWS SDK for Ruby v3 - SESv2

Please use version 0.1.x of this gem for legacy Ruby and AWS SDK support.

## Getting Started

In your `Gemfile`:

```ruby
gem "tt-mail-ses", require: "mail-ses"
```

Next, make a new initializer at `config/initializers/mail_ses.rb`:

```ruby
ActionMailer::Base.add_delivery_method :ses, Mail::SES,
    region: 'us-east-1',
    access_key_id: 'abc',
    secret_access_key: '123'
```

Finally, in the appropriate `config/environments/*.rb`:

```ruby
config.action_mailer.delivery_method = :ses
```

## Advanced Usage

### AWS SES Client Options

Any options supported by the `Aws::SESV2::Client` class can be passed into the initializer, for example:

```ruby
ActionMailer::Base.add_delivery_method :ses, Mail::SES,
    region: 'us-east-1',
    session_token: 'foobar',
    retry_limit: 5,
    retry_max_delay: 10,
    message_id_domain: "eu-west-1.amazonses.com"
```

In addition, the shortcut option `:use_iam_profile (Boolean)` which activates the IAM instance profile.

```ruby
ActionMailer::Base.add_delivery_method :ses, Mail::SES,
    region: 'us-east-1',
    use_iam_profile: true
```

### Default Mail Options

In the initializer you can set `:mail_options (Hash)` which are default options to pass-through to each mail sent:

```ruby
ActionMailer::Base.add_delivery_method :ses, Mail::SES,
    # ...
    mail_options: {
      from_email_address_identity_arn: 'arn:aws:ses:us-east-1:123456789012:identity/example.com',
      email_tags: [
        { name: 'MessageTagName', value: 'MessageTagValue' },
      ],
    }
```

### Override Mail Options

You can override the default mail options on a per-mail basis by passing them in the `mail` method:

```ruby
class ApplicationMailer < ActionMailer::Base
  def example
    mail(
      to: "foo@example.com",
      from: "bar@example.com",
      mail_options: {
        email_tags: [
          { name: 'MessageTagName', value: 'MessageTagValue' },
        ],
      }
    )
  end
end
```

### AWS Error Handling

To handle errors from AWS API, in the initializer you can set `:error_handler (Proc)` which takes two args:
the error which was raised, and the raw_email options hash. This is useful for notifying your bug tracking service.
Setting `:error_handler` causes the error to be swallowed unless it is raised again in the handler itself.

```ruby
ActionMailer::Base.add_delivery_method :ses, Mail::SES,
    # ...
    error_handler: ->(error, raw_email) do
      Bugsnag.notify(error){|r| r.add_tab('email', { email: raw_email })}
      raise error
    end
```

### Send Email as a Standalone

You can send one-off mails using the `Mail::SES` object and `#deliver` method.

```ruby
mail = Mail.new(args)

ses  = Mail::SES.new(region: 'us-east-1',
                     access_key_id: 'abc',
                     secret_access_key: '123')

options = { from_email_address_identity_arn: 'arn:aws:ses:us-east-1:123456789012:identity/example.com' }

ses.deliver!(mail, options) #=> returns AWS API response

mail.message_id #=> "00000138111222aa-33322211-cccc-cccc-cccc-ddddaaaa0680-000000@email.amazonses.com"
```

Please also see the [AWS SDK v3 for SES](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-using-sdk-ruby.html) for alternate approaches.

### Statistics, Verified Addresses, Bounce Rate, etc.

Please use the official [AWS SDK v3 for SES](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-using-sdk-ruby.html).

## Copyright

Copyright (c) 2024 [Teamtailor](http://www.teamtailor.com/). See LICENSE for further details.

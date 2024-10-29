# Changelog

### 1.2.0

- Support different message_id domains for different AWS SES regions. [#10](https://github.com/tablecheck/mail-ses/pull/10)
- Support options via message headers. [#2](https://github.com/Teamtailor/mail-ses/pull/2), [ad18f13](https://github.com/Teamtailor/mail-ses/commit/ad18f133ecaa6d6a5c4765930fe1b3b413a498a8) and [00a3e97](https://github.com/Teamtailor/mail-ses/commit/00a3e97fea5caba10b5d9ef0d418f26ccb4b0e61)
- Use Standard instead of Rubocop.
- Publish the fork as a separate gem: [tt-mail-ses](https://rubygems.org/gems/tt-mail-ses).

### 1.1.0

- Mail Gem: Bump minimum version dependency to 2.8.1.

### 1.0.5

- Pass-thru invalid email addresses.

### 1.0.4

- Fix missing method error related to message headers.

### 1.0.3

- Support UTF-8 chars in from, to, etc addresses.

### 1.0.2

- Fix labels in being stripped from email addresses.
- Support Reply-To address.

### 1.0.1

- Add compatibility with Mail gem 2.8.0.

### 1.0.0

- BREAKING CHANGE: Upgrade to AWS Ruby SDK v3 - SESv2 API ([@khrvi](https://github.com/khrvi))
- Drop support for Ruby 2.5 and earlier.
- Switch CI from Travis to Github Actions.
- Add Rubocop to CI.
- Refactor code.

### 0.1.2

- Fix: Add #settings method for conformity with other Mail delivery methods.

### 0.1.1

- Fix: Remove Base64 encoding from message body.

### 0.1.0

- Initial release of gem.
- Support for sending ActionMailer mails via AWS SDK v3.

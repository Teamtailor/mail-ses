# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "mail/ses/version"

Gem::Specification.new do |s|
  s.name = "tt-mail-ses"
  s.version = Mail::SES::VERSION
  s.licenses = ["MIT"]
  s.summary = "Ruby Mail delivery method handler for Amazon SES"
  s.description = "Ruby Mail delivery method handler for Amazon SES"
  s.authors = ["Jonas Brusman"]
  s.email = "platform@teamtailor.com"
  s.files = Dir.glob("lib/**/*") + %w[CHANGELOG.md LICENSE README.md]
  s.homepage = "https://github.com/teamtailor/mail-ses"
  s.required_ruby_version = ">= 3.0.0"

  s.add_dependency("aws-sdk-sesv2", ">= 1.27")
  s.add_dependency("mail", ">= 2.8.1")
  s.add_development_dependency("net-smtp")
  s.add_development_dependency("nokogiri")
  s.add_development_dependency("rake", ">= 1")
  s.add_development_dependency("rspec", ">= 3.8")
  s.add_development_dependency("standard", "1.41.1")

  s.metadata["rubygems_mfa_required"] = "true"
end

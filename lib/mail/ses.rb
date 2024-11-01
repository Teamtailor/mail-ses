# frozen_string_literal: true

require "mail/ses/version"
require "mail/ses/message_validator"
require "mail/ses/options_builder"

module Mail
  # Mail delivery method handler for AWS SES
  class SES
    attr_accessor :settings
    attr_reader :client

    # Initializes the Mail::SES object.
    #
    # options - The Hash options (optional, default: {}):
    #   :mail_options    - (Hash) Default AWS options to set on each mail object.
    #   :error_handler   - (Proc<Error, Hash>) Handler for AWS API errors.
    #   :use_iam_profile - Shortcut to use AWS IAM instance profile.
    #   All other options are passed-thru to Aws::SESV2::Client.
    def initialize(options = {})
      @mail_options = options.delete(:mail_options) || {}

      @error_handler = options.delete(:error_handler)
      raise ArgumentError.new(":error_handler must be a Proc") if @error_handler && !@error_handler.is_a?(Proc)

      @settings = {
        return_response: options.delete(:return_response),
        message_id_domain: options.delete(:message_id_domain)
      }

      options[:credentials] = Aws::InstanceProfileCredentials.new if options.delete(:use_iam_profile)
      @client = Aws::SESV2::Client.new(options)
    end

    # Delivers a Mail::Message object via SES.
    #
    # message - The Mail::Message object to deliver (required).
    # options - The Hash options which override any defaults set in :mail_options
    #           in the initializer (optional, default: {}). Refer to
    #           Aws::SESV2::Client#send_email
    def deliver!(message, options = {})
      MessageValidator.new(message).validate

      options = @mail_options.merge(options || {})
      send_options = OptionsBuilder.new(message, options).build

      begin
        response = client.send_email(send_options)
        message.message_id = "#{response.to_h[:message_id]}@#{settings[:message_id_domain] || "email.amazonses.com"}"
        settings[:return_response] ? response : self
      rescue => e
        handle_error(e, send_options)
      end
    end

    private

    def handle_error(error, send_options)
      raise(error) unless @error_handler

      @error_handler.call(error, send_options.dup)
    end
  end
end

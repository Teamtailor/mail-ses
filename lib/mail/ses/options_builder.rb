# frozen_string_literal: true

module Mail
  class SES
    # Builds options for Aws::SESV2::Client#send_email
    class OptionsBuilder
      SES_FIELDS = %i[ from_email_address
        from_email_address_identity_arn
        reply_to_addresses
        feedback_forwarding_email_address
        feedback_forwarding_email_address_identity_arn
        email_tags
        configuration_set_name ].freeze

      # message - The Mail::Message object to be sent.
      # options - The Hash options which override any defaults
      #           from the message.
      def initialize(message, options = {})
        @message = message
        @options = options
      end

      # Returns the options for Aws::SESV2::Client#send_email.
      def build
        mail_options = ses_options_from_message
        message_options.merge(ses_options, mail_options)
      end

      private

      def ses_options
        # TODO: address fields should be encoded to UTF-8
        slice_hash(@options, *SES_FIELDS)
      end

      def ses_options_from_message
        mail_options = @message[:mail_options]&.unparsed_value

        if mail_options
          @message[:mail_options] = nil
          slice_hash(mail_options, *SES_FIELDS)
        else
          {}
        end
      end

      def message_options
        {
          from_email_address: extract_value(:from)&.first,
          reply_to_addresses: extract_value(:reply_to),
          destination: {
            to_addresses: extract_value(:to) || [],
            cc_addresses: extract_value(:cc) || [],
            bcc_addresses: extract_value(:bcc) || []
          },
          content: {raw: {data: @message.to_s}}
        }.compact
      end

      def slice_hash(hash, *keys)
        keys.each_with_object({}) { |k, h| h[k] = hash[k] if hash.key?(k) }
      end

      def extract_value(key)
        value = @message.header[key]
        return unless value

        if value.respond_to?(:formatted)
          value.formatted
        elsif value.respond_to?(:unparsed_value)
          Array(value.unparsed_value)
        else
          []
        end&.map { |v| encode(v) }
      end

      def encode(value)
        Mail::Encodings.address_encode(value)
      end
    end
  end
end

module StripeBilling
  class WebhooksBuilder
    def initialize
      @webhooks = HashWithIndifferentAccess.new
    end

    def process(*args, with:)
      handlers = Array.wrap(with).map { |handler_name| "StripeBilling::WebhookHandlers::#{handler_name.camelize}Job".safe_constantize }
      args.each do |arg|
        webhooks[arg] ||= []
        webhooks[arg] += handlers
        webhooks[arg].uniq!
      end
    end

    def build
      webhooks.freeze
    end

    private

    attr_reader :webhooks
  end
end

module StripeBilling
  class WebhooksBuilder
    def initialize
      @webhooks = HashWithIndifferentAccess.new
    end

    def process(*args, with:)
      args.each do |arg|
        webhooks[arg] ||= []
        webhooks[arg] += Array.wrap(with)
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

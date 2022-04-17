module StripeBilling
  class ApplicationJob < ::ApplicationJob
    rescue_from StandardError, with: :log_and_report_error

    REPORTING_TAGS = ["active-job"].freeze

    private

    def log_and_report_error(error, **kwargs)
      kwargs[:tags] ||= []
      kwargs[:tags].concat(REPORTING_TAGS).uniq!

      kwargs[:parameters] = arguments.inject({}) do |acc, arg|
        if arg.respond_to?(:to_global_id)
          acc[acc.length] = arg.to_global_id.to_s
        else
          acc[acc.length] = arg
        end
        acc
      end

      logger.error(error.message, error: error.class.name, **kwargs)
      StripeBilling.error_reporter.call(error, **kwargs.merge(sync: true))
    end
  end
end

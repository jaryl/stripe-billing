module StripeBilling
  class Feature
    include ActiveModel::Model
    include ActiveModel::Validations

    def build
      self.freeze
    end
  end
end

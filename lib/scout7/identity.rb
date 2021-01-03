# frozen_string_literal: true

module Scout7
  # Gem identity information.
  module Identity
    def self.name
      "scout7"
    end

    def self.label
      "Scout7"
    end

    def self.version
      "0.1.0"
    end

    def self.version_label
      "#{label} #{version}"
    end
  end
end

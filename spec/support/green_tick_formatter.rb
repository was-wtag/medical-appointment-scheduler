# frozen_string_literal: true

require 'rspec/core/formatters/documentation_formatter'

class GreenTickFormatter < RSpec::Core::Formatters::DocumentationFormatter
  RSpec::Core::Formatters.register self, :example_passed

  def example_passed(notification)
    output.puts "\e[32m✓ #{notification.example.description.strip}\e[0m"
  end
end

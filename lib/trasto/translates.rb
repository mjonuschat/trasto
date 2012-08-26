module Trasto
  module Translates
    def translates(*columns)

      extend Trasto::ClassMethods
      include Trasto::InstanceMethods

      # Don't overwrite values if running multiple times in the same class
      # or in different classes of an inheritance chain.
      unless respond_to?(:translatable_columns)
        class_attribute :translatable_columns
        self.translatable_columns = []
      end

      self.translatable_columns |= columns.map(&:to_sym)

      columns.each do |column|

        define_method(column) do
          read_localized_value(column)
        end

        define_method("#{column}=") do |value|
          write_localized_value(column, value)
        end

      end
    end
  end
end

ActiveRecord::Base.send :extend, Trasto::Translates

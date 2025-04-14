# frozen_string_literal: true

# BEGIN
module Model
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      @attributes_options = {}

      class << self
        attr_reader :attributes_options
      end
    end
  end

  module ClassMethods
    def attribute(name, options ={})
      @attributes_options[name] = options

      define_method(name) do
        value = instance_variable_get("@#{name}")

        return value if value.nil?
        
        if self.class.attributes_options[name][:type]
          type = self.class.attributes_options[name][:type]

          case type
          when :string
            String(value)
          when :integer
            Integer(value)
          when :boolean
            [true, 1, '1', "t", "T", "true", "TRUE"].include?(value)
          when :datetime
            DateTime.parse(value.to_s)
          else
            if type.is_a?(Class)
              type.new(value)
            else
              value
            end
          end
        else
          value
        end
      end

      define_method("#{name}=") do |value|
        instance_variable_set("@#{name}", value)
      end
    end
  end    
   
  def initialize(attributes = {})
    attributes.each do |name, value|
      if respond_to?("#{name}=")
        public_send("#{name}=", value)
      end
    end

    self.class.attributes_options.each do |attr_name, options|
      if options.key?(:default) && !instance_variable_defined?("@#{attr_name}")
        instance_variable_set("@#{attr_name}", options[:default])
      end
    end
  end

  def attributes
    result = {}
    
    self.class.attributes_options.keys.each do |attr_name|
      result[attr_name] = public_send(attr_name)
    end
    
    result
  end
end
# END

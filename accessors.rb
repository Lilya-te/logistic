module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_name_history = "@#{name}_history".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}_history") { instance_variable_get(var_name_history) }
      define_method("#{name}=".to_sym) { |value| instance_variable_set(var_name, value) }
      define_method("#{name}_history=".to_sym) { |value| instance_variable_set(var_name_history, (instance_variable_get(var_name_history).to_a) << value) }
    end
  end
end
module Accessors

  # Этот метод динамически создает геттеры и сеттеры для любого кол-ва атрибутов,
  # при этом сеттер сохраняет все значения инстанс-переменной при изменении этого значения.
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_name_history = "@#{name}_history".to_sym
      define_method(name.to_sym) { instance_variable_get(var_name) }
      define_method("#{name}_history".to_sym) { instance_variable_get(var_name_history) }
      define_method("#{name}_history=".to_sym) do |value|
        instance_variable_set(var_name_history, (instance_variable_get(var_name_history).to_a) << value)
      end
      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)
        eval "#{"self.#{name}_history=".to_sym}'#{value}'"
      end
    end
  end

  # принимает имя атрибута и его класс.
  # При этом создается геттер и сеттер для одноименной инстанс-переменной,
  # но сеттер проверяет тип присваемоего значения.
  # Если тип отличается от того, который указан вторым параметром, то выбрасывается исключение.
  # Если тип совпадает, то значение присваивается.
  def strong_attr_accessor(name, klass)
    define_method(name.to_sym) { instance_variable_get("@#{name}") }
    define_method("#{name}=".to_sym) do |value|
      if value.is_a?(klass)
        instance_variable_set("@#{name}", value)
      else
        raise StandardError, "Impossible value. Value type must be #{klass}"
      end
    end
  end
end

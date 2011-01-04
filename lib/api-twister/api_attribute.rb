module ApiTwister
  class ApiAttribute
    attr_accessor :name, :description, :data_type, :required

    def initialize(name, data_type, description, required)
      @name = name
      @description = description
      @data_type = data_type
      @required = required
    end
  end
end

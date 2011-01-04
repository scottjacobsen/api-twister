module ApiTwister
  class ApiDefinition
    attr_reader :api_items
    attr_accessor :model

    TYPE_MAP = {:association => ApiAssociation, :method => ApiMethod, :attribute => ApiAttribute}
    def all_items(type = nil)
      if type
        @api_items.select {|k, v| v.kind_of?(TYPE_MAP[type])}.keys
      else
        @api_items.keys
      end
    end

    def initialize(model)
      @has_attributes = false
      @model = model
      @api_items = {}
    end

    def association(assoc)
      @api_items[assoc] = ApiAssociation.new(model, assoc)
    end

    def associations(*assocs)
      assocs.each {|a| association a}
    end

    def attribute(attrib, data_type = "string", description = nil, required = false)
      @has_attributes = true
      @api_items[attrib] = ApiAttribute.new(attrib, data_type, description, required)
    end

    def attributes(*attribs) 
      attribs.each {|a| attribute a }
    end

    def method(meth, data_type = "string", description = nil, required = false)
      @api_items[meth] = ApiMethod.new(meth, data_type, description, required)
    end

    def methods(*meths)
      meths.each {|m| method m}
    end

    def has_attributes?
      @has_attributes
    end
  end
end

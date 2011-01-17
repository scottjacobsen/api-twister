module ApiTwister
  class ApiDefinition
    attr_reader :api_items
    attr_accessor :model, :node_name

    TYPE_MAP = {:association => ApiAssociation, :method => ApiMethod, :attribute => ApiAttribute, :code_table => CodeTable}
    # Returns a list of symbols where the symbol is the name of the item
    def all_items(type = nil)
      if type
        @api_items.select {|k, v| v.kind_of?(TYPE_MAP[type])}.keys
      else
        @api_items.keys
      end
    end

    def all_objects(type = nil)
      if type
        @api_items.select {|k, v| v.kind_of?(TYPE_MAP[type])}.values
      else
        @api_items.values
      end
    end

    def initialize(model, options = {})
      @has_attributes = false
      @model = model
      @api_items = {}
      @node_name = options[:node_name] || model.name.underscore.dasherize
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

    alias_method :orig_method, :method
    def method(meth, data_type = "string", description = nil, required = false)
      @api_items[meth] = ApiMethod.new(meth, data_type, description, required)
    end

    alias_method :orig_methods, :methods
    def methods(*meths)
      meths.each {|m| method m}
    end

    def code_table(name, table_name, order_by=nil)
      @api_items[name] = CodeTable.new(name, table_name, order_by)
    end

    def has_attributes?
      @has_attributes
    end
  end
end

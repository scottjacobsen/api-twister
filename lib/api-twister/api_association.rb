module ApiTwister
  class ApiAssociation
    attr_reader :association

    def initialize(model, association)
      @model = model
      @association = association
    end

    def api_hash(name, options={})
      hash = {}
      assoc = @model.reflect_on_association(@association)
      raise "There is no association named #{@association}" if assoc.nil?
      klass = eval(assoc.class_name)
      if klass.respond_to? :api_hash
        hash[@association] = klass.api_hash(name, options)
      else
        hash[@association] = {}
      end
    end
  end
end

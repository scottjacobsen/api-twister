module ApiTwister
  module Documentation
    def Documentation.included(base)
      base.class_eval <<-eos
      class_inheritable_accessor :_api_definition
      class_inheritable_accessor :_api_specifications
      extend ClassMethods
      include InstanceMethods
    eos
    end

    module ClassMethods
      def node_name(options = {})
        #TODO: If a user is passed filter by permissions
        self._api_definition.node_name
      end

      def doc_attributes(options = {})
        # return a list of attributes and methods
        #TODO: If a user is passed filter by permissions
        self._api_definition.all_objects(:attribute) + self._api_definition.all_objects(:method) 
      end

      def doc_code_tables(options = {})
        #TODO: If a user is passed filter by permissions
        self._api_definition.all_objects(:code_table)
      end
    end
  end
end

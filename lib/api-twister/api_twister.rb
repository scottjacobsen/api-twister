module ApiTwister
  def ApiTwister.included(base)
    base.class_eval <<-eos
      class_inheritable_accessor :_api_definition
      class_inheritable_accessor :_api_specifications
      extend ClassMethods
      include InstanceMethods
    eos
  end

  module ClassMethods
    def define_api(options={})
      self._api_definition ||= ApiDefinition.new(self)

      yield self._api_definition if block_given?

      # if no attributes were added in block, add all the attributes here
      unless self._api_definition.has_attributes?
        self.new.attributes.symbolize_keys.keys.each { |k| _api_definition.attribute k }
      end

      self._api_definition
    end

    def api(name, options={})
      self._api_specifications ||= {}
      _api_specifications[name] ||= []
      
      if options[:only]
        options[:only].each do |only|
          if [:methods, :attributes, :associations].include?(only)
            _api_specifications[name] << _api_definition.all_items(only.to_s.singularize.to_sym)
          else
            _api_specifications[name] << only
          end
        end
      elsif options[:except]
        everything = _api_definition.all_items
        except_list = []
        options[:except].each do |except|
          if [:methods, :attributes, :associations].include?(except)
            except_list << _api_definition.all_items(except.to_s.singularize.to_sym)
          else
            except_list << except
          end
        end
        except_list.flatten!
        everything.flatten!
        _api_specifications[name]  = everything - except_list
      else
        self._api_specifications[name] = _api_definition.all_items
      end
      _api_specifications[name].flatten!
    end

    def api_hash(name, options = {})
      spec = self._api_specifications[name]
      hash = { :only => [] }
      user = options[:user]

      spec.each do |item|
        object = self._api_definition.api_items[item]
        if object.is_a?(ApiMethod)
          hash[:methods] ||= []
          hash[:methods] << item if user_has_permission?(user, item)
        elsif object.is_a?(ApiAttribute)
          hash[:only] << item if user_has_permission?(user, item)
        else
          raise "Nil object. Spec: #{spec}, Item: #{item}" if object.nil?
          hash[:include] ||= {}
          hash[:include][item] = object.api_hash(name, options) if user_has_permission?(user, object.association)
        end
      end if spec
      hash
    end

    def exposes_as(item)
      value = _api_definition.api_items[item.to_sym]
      value.is_a?(ApiAssociation) ? :association : value
    end

    private

    def user_has_permission?(user, item)
      user.nil? || user.has_permission?(self, item)
    end
  end

  module InstanceMethods
    def api_hash(name, options={})
      self.class.api_hash name, options
    end

    def to_api_xml(name, options={})
      to_xml(api_hash(name, options))
    end

    def to_api_json(name, options={})
      to_json(api_hash(name, options))
    end
  end
end

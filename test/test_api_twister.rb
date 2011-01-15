require File.expand_path('test_helper.rb', File.dirname(__FILE__))
require 'mocha'
class ApiTwisterTest < Test::Unit::TestCase

  context "A class with the default api specification" do
    setup do
      class AttributesOnly
        
        def attributes
          {"abc" => nil, "xyz" => nil}
        end
        
        def test_method; end
        
        include ApiTwister
        define_api
        api :request
      end

    end

    should "should only have attributes in the api_hash" do
      assert_equal({:only => [:abc, :xyz]}, AttributesOnly.api_hash(:request))
    end
  end

  context "A class that defines only the methods as part of the API" do
    setup do
      class KlassWithMethod
        include ApiTwister
        
        def attributes
          {"abc" => nil, "xyz" => nil}
        end
        
        def test_method; end
        
        define_api do |api|
          api.method :test_method
        end
        
        api :request
      end
    end

    should "Have methods and attributes as part of the API because attributes are included by default" do
      assert_equal({:methods => [:test_method], :only => [:abc, :xyz]}, KlassWithMethod.api_hash(:request))
    end
  end

  context "A class that defines only attributes as a part of the API" do
    setup do
      class KlassWithAttributes
        include ApiTwister
        extend Mocha::API

        def attributes
          {"abc" => nil, "xyz" => nil}
        end

        def test_method; end
        
        def self.reflect_on_association(*args)
          association_fake = stub(:nil? => false, :class_name => 'Hash')
        end
        
        define_api do |api|
          api.association :another_class
        end

        api :request
      end
    end

    should "Have associations and attributes as part of the API because attributes are included by default" do
      assert_equal({:include => {:another_class => {}}, :only => [:abc, :xyz]}, KlassWithAttributes.api_hash(:request))
    end
  end
end


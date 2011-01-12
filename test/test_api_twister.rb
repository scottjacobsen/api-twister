require File.expand_path('test_helper.rb', File.dirname(__FILE__))
class ApiTwisterTest < Test::Unit::TestCase
  context "Simple class" do
    setup do
      class TestKlass
        def attributes
          {"abc" => nil, "xyz" => nil}
        end

        include ApiTwister
        define_api
        api :request
        api :response
      end

    end

    should "work" do
      # mock attributes

      k = TestKlass.new
      assert k.attributes.keys.include? "abc"
      #
      # assert k.to_api_xml(:request).include? "<abc>"
      # puts k.to_api_json(:request)
      # assert k.to_api_json(:request)
    end

  end
end

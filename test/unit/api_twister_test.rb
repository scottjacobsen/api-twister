require 'test_helper'

class ApiTwisterTest < Test::Unit::TestCase
  context "Simple class" do
    setup do
      class TestKlass
        def attributes
          {"abc" => nil, "xyz" => nil}
        end

        include ApiTwister
        define_api
      end

    end

    should "work" do
      # mock attributes

      k = TestKlass.new
      assert k.attributes.keys.include? "abc"

    end

  end
end
module ApiTwister
class CodeTable
  attr_accessor :name, :table_name

  def initialize(name, table_name, order_by=nil)
    @name = name
    @table_name = table_name
    @order_by = order_by
  end

  def code_values
    @code_values ||= load_code_values
  end

  private

  def load_code_values
    sql = "select * from #{table_name}"
    sql << " order by #{@order_by}" if @order_by
    ActiveRecord::Base.connection.select_all(sql).collect{|r| CodeValue.new(r)}
  end
  
end
end

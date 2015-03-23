class ApiResponse
  attr_accessor :results,
                :total_rows,
                :error

  def initialize(results=[], total_rows=0, error=nil)
    @results = results
    @total_rows = total_rows
    @error = error
  end
end
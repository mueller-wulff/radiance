class GradesController < ApplicationController
  def index
    @gradeable = find_gradeable
    @grades = @gradeable.grades
  end
  
  def find_gradeable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end

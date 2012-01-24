# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Stitched::Application.initialize!

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  '<span class="input">'.html_safe << html_tag << 
    '</span>'.html_safe
end

Rails.logger = Logger.new(STDOUT)

# Include hook code here
#require 'checkbox_select'
require 'sexy_select'
ActionView::Base.send(:include, SexySelectHelper)
ActionView::Helpers::FormBuilder.send(:include, SexySelectBuilder)

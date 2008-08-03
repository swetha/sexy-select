#module ActionView
#  module Helpers
#    module FormHelper

module SexySelectHelper
      def sexy_select(object, method, choices, options = {})
        counter = ((options[:counter].blank? or options[:multi] == true) ? "none" : options[:counter]).to_s
        unique_id = options[:id] || rand(10000)
        object, method, title = object.to_s.dup, method.to_s.dup, (options[:title] || "- Select -")
        id_head = "#{object}[#{method}]_#{unique_id}"
        selected = options[:object].send(method) rescue self.instance_variable_get("@#{object}").send(method)
        case options[:noun]
        when NilClass
          @nouns = "['#{method.singularize.titleize}','#{method.singularize.pluralize.titleize}']"
        when String
          @nouns = "['#{options[:noun]}', '#{options[:noun].pluralize}']"
        when Hash
          @nouns = "['#{options[:noun][:singular]}', '#{options[:noun][:plural]}']"
        when Array
          @nouns = "['#{options[:noun][0]}', '#{options[:noun][1]}']"
        end

        checkbox_list = choices.map do |element|
          case element
            when Hash
              element.symbolize_keys!
              select_option = element[:option]
              select_value = element[:value]
            when Array
              select_option = element[0]
              select_value = element[1] || select_option
            when String
              select_option = element
              select_value = element
          end

          ["<input type='checkbox' name='#{object}[#{method}][]' "+
           "id='#{id_head}-#{select_value}' "+
           (selected.nil? ? "" : "#{selected.include?(select_value) ? 'checked=\'checked\'' : nil} ")+
           "value='#{(select_value)}' "+
           "#{options[:disabled] == true ? "disabled='true'" : ''} "+
           build_sexy_select_onclick("#{id_head}", select_value, counter, title) + ">"+
           build_sexy_select_link("#{id_head}", select_value, select_option, counter, title)]
        end
       
        #build_sexy_select
        wrapper = "<div id='#{id_head}' class='sexy_select_wrapper' "+
		  "style='width:#{(options[:size].blank? ? '150' : options[:size].to_s)}px; padding: 0px 2px;'>\n"
        clear_selection = link_to_function("Clear Selected", "$$('input[id^=#{object}[#{method}]]_#{unique_id}]').invoke('setDOMAttribute','checked','false');"+
                          "sexy_select_rewrite_title_with_count('#{id_head}', #{@nouns}, #{counter.to_s == "only" ? false : "'"+title+"'"}, 0)")+"<br/>\n"
        list = "<div class='checkbox_list'>\n"
        
        if options[:multiple] == true
          header = ""
          main = "<div id='#{id_head}-main' class='sexy_select_multiple'>\n"
        else
          selected_count = selected.size rescue 0
          if (counter == "both" and selected_count > 0) or counter == "only"
            title = "#{pluralize(selected_count, eval(@nouns).first, eval(@nouns).last)} Selected"
          end
          script = "\n<script> <!--\n sexy_select_setup('#{id_head}');\n//-->\n</script>\n"
          header = "<div id='#{id_head}-header' class='sexy_select_top' onclick='sexy_select_main_toggle(\"#{id_head}-main\" );'>\n"+
                    "#{title}\n</div>"
          main = "<div id='#{id_head}-main' class='sexy_select'>\n"
        end
        "#{script || ""}#{wrapper}#{header}#{main}#{list}#{checkbox_list.join("<br/>\n")}\n</div>\n#{clear_selection}\n</div>\n</div>"
      end

      def build_sexy_select_link(id_head, cat_id,  name, counter, title)
        case counter.to_s
        when "none"
          link_to_function(name,"sexy_select_toggle('#{id_head}-#{cat_id}')", :title => name)
        when "both"
          link_to_function(name, "sexy_select_toggle_then_change_count_with_title('#{id_head}', '#{cat_id}', #{@nouns}, '#{title}')", :title => name)
        when "only"
          link_to_function(name, "sexy_select_toggle_then_change_count('#{id_head}', '#{cat_id}', #{@nouns})", :title => name)
        end
      end

      def build_sexy_select_onclick(id_head, cat_id, counter, title)
        case counter.to_s
        when "none"
          ""
        when "both"
          "onclick=\"false; sexy_select_change_count_with_title('#{id_head}', #{@nouns}, '#{title}');\""
        when "only"
          "onclick=\"false; sexy_select_change_count('#{id_head}', #{@nouns});\""
        end
      end
end

module SexySelectBuilder
    # Rebuild the FormBuilder methods
      def sexy_select(method, choices, options = {})
        @template.sexy_select(@object_name, method, choices,  options.merge(:object => @object))
      end
end

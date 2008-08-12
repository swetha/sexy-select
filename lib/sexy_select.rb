module SexySelectHelper
      def sexy_select(object, method, choices, options = {}, html_options = {})
	options.symbolize_keys!; html_options.symbolize_keys!
        counter = ((options[:counter].blank? or html_options[:multiple] == true) ? "none" : options[:counter]).to_s
        unique_id = options[:id] || rand(10000)
        object, method, title = object.to_s, method.to_s, (options[:title] || "- Select -")
        @id_head = "#{object}_#{method}_#{unique_id}"
        selected = options[:object].send(method) rescue self.instance_variable_get("@#{object}").send(method)
	@nouns = determine_nouns(options[:noun], method)
        checkbox_list = build_choices("#{object}[#{method}][]", choices, selected, counter, title, html_options)

        #build_sexy_select
	script = ""
	clear_selection(object, method, counter, title, unique_id) #cache the link...
        sexy_tag = content_tag(:div, :id => @id_head, :class => 'sexy_select_wrapper', :style => "width: #{(html_options[:width] || 150).to_s}px; padding: 0px 2px;") do
		if html_options[:multiple] == true
			build_main("_multiple", checkbox_list)
		else
			selected_count = selected.size rescue 0
			if (counter == "both" and selected_count > 0) or counter == "only"
			  title = "#{pluralize(selected_count, eval(@nouns).first, eval(@nouns).last)} Selected"
			end
			script = content_tag(:script) {"<!-- \n sexy_select_setup('#{@id_head}');\n//-->"}
			content_tag(:div, :id => @id_head+"-header", :class => "sexy_select_top", :onclick => "sexy_select_main_toggle(\"#{@id_head}-main\" );") {title} + build_main(nil, checkbox_list)
		end
	end
	script+sexy_tag
      end

      def clear_selection(object, method, counter, title, unique_id)
	@clear_link_cache ||= link_to_function("Clear Selected", "$$('input[id^=#{object}_#{method}_#{unique_id}]').invoke('setDOMAttribute','checked','false');"+
                         "sexy_select_rewrite_title_with_count('#{@id_head}', #{@nouns}, #{counter.to_s == "only" ? false : "'"+title+"'"}, 0)")+"<br/>\n"
      end

      def build_main(class_append, checkbox_list)
	content_tag(:div, :id => "#{@id_head}-main", :class => "sexy_select#{class_append}" ) { content_tag(:div, :class => "checkbox_list") { checkbox_list.join("<br/>\n") } + clear_selection(nil, nil, nil, nil, nil) }
      end


      def build_sexy_select_link(cat_id, name, counter, title)
        case counter.to_s
        when "none"
          link_to_function(name,"sexy_select_toggle('#{@id_head}_#{cat_id}')", :title => name)
        when "both"
          link_to_function(name, "sexy_select_toggle_then_change_count_with_title('#{@id_head}', '#{cat_id}', #{@nouns}, '#{title}')", :title => name)
        when "only"
          link_to_function(name, "sexy_select_toggle_then_change_count('#{@id_head}', '#{cat_id}', #{@nouns})", :title => name)
        end
      end

      def build_sexy_select_onclick(cat_id, counter, title)
        case counter.to_s
        when "none"
          ""
        when "both"
          "false; sexy_select_change_count_with_title('#{@id_head}', #{@nouns}, '#{title}');"
        when "only"
          "false; sexy_select_change_count('#{@id_head}', #{@nouns});"
        end
      end

      def determine_nouns(noun, method)
        case noun
        when NilClass
          "['#{method.singularize.titleize}','#{method.singularize.pluralize.titleize}']"
        when String
          "['#{noun}', '#{noun.pluralize}']"
        when Hash
          "['#{noun[:singular]}', '#{noun[:plural]}']"
        when Array
          "['#{noun[0]}', '#{noun[1]}']"
        end
      end

      def build_choices(name, choices, selected, counter, title, html_options = {})
	result = choices.map do |element|
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

	  tag(:input, {:type => "checkbox", :name => name, :id => "#{@id_head}_#{select_value}", :checked => (selected.nil? ? nil : (selected.include?(select_value) ? "checked='checked'" : nil) ),
		      :value => select_value, :disabled => html_options[:disabled], :onclick => build_sexy_select_onclick(select_value, counter, title)})+
#          build_sexy_select_link(select_value, select_option, counter, title)
          content_tag(:label, select_option, :for => "#{@id_head}_#{select_value}", :class => "sexy-select-label")
	end
	result
      end

end

module SexySelectBuilder
    # Rebuild the FormBuilder methods
      def sexy_select(method, choices, options = {}, html_options = {})
        @template.sexy_select(@object_name, method, choices, options.merge(:object => @object), html_options)
      end
end

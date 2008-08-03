var sexy_select_methods = {
	setDOMAttribute: function(element, attr, value){
		element = $(element);
		eval("element." + attr + "=" + value + ";");
		return element;
	},
	
	getDOMAttribute: function(element, attr){
		element = $(element);
		return eval("element." + attr + ";");
	}
}

Element.addMethods(sexy_select_methods);

function sexy_select_toggle(id)  {
	$(id).checked = ($(id).checked == true ? false : true);
}

function sexy_select_counter(id) {
        var counter = 0;
        $$("input[id^='"+id+"']").map(function(e) { return (e.checked ? 1 : 0); }).each(function(e) { counter += e;}); 
        return counter;
}

function sexy_select_rewrite_title_with_count(id, nouns, title, current_count) {
        element = $(id+"-header");
        if(title && current_count == 0) {
          element.innerHTML = title;
        } else {
          element.innerHTML = current_count.toString()+" "+(current_count == 1 ? nouns[0] : nouns[1])+" Selected";
        }
}

function sexy_select_toggle_then_change_count(id, cat_id, nouns) {
        sexy_select_toggle_then_change_count_with_title(id, cat_id, nouns, false);
}

function sexy_select_toggle_then_change_count_with_title(id, cat_id, nouns, title) {
        sexy_select_toggle(id+"-"+cat_id);
        sexy_select_change_count_with_title(id, nouns, title);
}

function sexy_select_change_count_with_title(id, nouns, title) {
        sexy_select_rewrite_title_with_count(id, nouns, title, sexy_select_counter(id));
}

function sexy_select_change_count(id, nouns) {
        sexy_select_change_count_with_title(id, nouns, false);
}

function sexy_select_main_toggle(id) {
	$(id).style.display = ($(id).style.display == 'block' ? 'none' : 'block')
}

function sexy_select_setup(id) {
	document.observe('dom:loaded', function() {
		sexy_select_offclick_observer(id);
	});
}

function sexy_select_offclick_observer(id) {
	document.observe('click', function(event){
		element = $(id+"-main");
		ignore = $(id+"-header");
		if (element.visible() && !event.target.descendantOf(element) && event.target != element && event.target != ignore) {
			element.hide();
		}
	});
}

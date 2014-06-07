function Search(search_id, result_id) {
	this.search_input = document.getElementById(search_id);
	this.result_div = document.getElementById(result_id);
}

Search.prototype.processSearch = function(param1, param2) {
	var xhr = new XMLHttpRequest();
	var r_div = this.result_div;
	xhr.onreadystatechange = function() {
		if(xhr.readyState == 4 && xhr.status == 200) {
			var obj = JSON.parse(xhr.responseText);
			var user_ids = obj[param1];
			var photo_names = obj[param2];
			var html = '';
			if(photo_names.length == 0){
				html += '<p class="no_results">Your search returned no results.</p>'	
			} else {
				html += '<table cellspacing="0">';
				for(var i = 0; i < photo_names.length; i++) {
					if(i != 0 && i % 3 == 0) html += '<tr>';
					html += '<td class="image"><a href="/photos/index/'+ user_ids[i] +'#'+ photo_names[i] +'"><img src="/images/'+ photo_names[i] +'" class="thumbnail" /></a></td>'
					if(i != 0 && i % 3 == 0) html += '</tr>';	
				}
				html += '</table>';
			}
			r_div.innerHTML = html;
		}
	}
	var s_value = encodeURIComponent(this.search_input.value);
	if(s_value != "") {
		xhr.open("GET", "/users/photo_search/" + s_value, true);
		xhr.send();
	} else {
		this.result_div.innerHTML = '';	
	}
}
function Tagger(tagged_id, feedback_id, image_id, hidden_x_id, hidden_y_id, hidden_width_id, hidden_height_id) {
	this.isMouseDown = false;
	this.tagged_element = document.getElementById(tagged_id);
	this.box = document.getElementById(feedback_id);
	this.box.style.display = "none";
	this.tagged_image = document.getElementById(image_id);
	this.hidden_x = document.getElementById(hidden_x_id);
	this.hidden_y = document.getElementById(hidden_y_id);
	this.hidden_width = document.getElementById(hidden_width_id);
	this.hidden_height = document.getElementById(hidden_height_id);
	var obj = this;
	this.tagged_element.onmousedown = function(event) {
		obj.mouseDown(event);	
	}
}	

Tagger.prototype.mouseDown = function(event) {
	event.preventDefault();
	var obj = this;
	if(event.clientX > (this.tagged_image.width + this.tagged_element.offsetLeft) || event.clientY > (this.tagged_image.height + this.tagged_element.offsetTop)){
		return;	
	}
	this.box.orig_x = event.clientX;
	this.box.orig_y = event.clientY;
	this.box.style.left = this.box.orig_x - this.tagged_element.offsetLeft + "px";
	this.box.style.top = this.box.orig_y - this.tagged_element.offsetTop + "px";
	this.box.style.width = 0;
	this.box.style.height = 0;
	this.box.style.display = "block"; 
	
	this.isMouseDown = true;
	this.oldMoveHandler = document.body.onmousemove;
	document.body.onmousemove = function(event) {
		obj.mouseMove(event);	
	}	
	this.oldUpHandler = document.body.onmouseup;
	document.body.onmouseup = function(event) {
		obj.mouseUp(event);	
	}
}

Tagger.prototype.mouseMove = function(event) {
	if(!this.isMouseDown) return;
	var curr_x = Math.min(event.clientX, this.tagged_image.width + this.tagged_element.offsetLeft);
	this.currX = Math.max(this.tagged_element.offsetLeft, curr_x);
	var curr_y = Math.min(event.clientY, this.tagged_image.height + this.tagged_element.offsetTop);
	this.currY = Math.max(this.tagged_element.offsetTop, curr_y);
	
	var currWidth = Math.abs(this.currX - this.box.orig_x);
	if(this.currX < this.box.orig_x) {
		this.box.style.left = (this.currX - this.tagged_element.offsetLeft) + "px";	
	}
	this.box.style.width = currWidth + "px";
	
	var currHeight = Math.abs(this.currY - this.box.orig_y);
	if(this.currY < this.box.orig_y) {
		this.box.style.top = (this.currY - this.tagged_element.offsetTop) + "px";	
	}
	this.box.style.height = currHeight + "px";
}

Tagger.prototype.mouseUp = function(event) {
	this.isMouseDown = false;
	
	this.hidden_x.value = parseInt(this.box.style.left);
	this.hidden_y.value = parseInt(this.box.style.top);
	this.hidden_width.value = parseInt(this.box.style.width);
	this.hidden_height.value = parseInt(this.box.style.height);
	
	document.body.onmousemove = this.oldMoveHandler;
	document.body.onmouseup = this.oldUpHandler;	
}
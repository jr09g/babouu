$(document).ready(function() {

	//below javascript enables the dropdown menu in the navbar for views
	$('.dropdown-toggle').dropdown();

	//below function should toggle receipts in all receipts page
	$(".click-me").click(function(){
		//toggles only the next element of the clicked header containing the click-me class
		$(this).next().toggle();
	});

});
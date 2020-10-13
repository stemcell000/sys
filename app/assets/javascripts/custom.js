//Initialisation des champs select avec Select2, hors fenêtres modales.
$(document).ready(function() {
    console.debug('select2 is initialized in this DOM!');
    
	$(".select2-select").select2({
		    theme: "bootstrap",
		    tag: true,
		    placeholder: "Select",
		    tokenSeparators: [',', ' '],
		    allowClear: true
		});
		
//Activation des chevron sur le bootstrap panel collapse
function toggleChevron(e) {
    $(e.target)
        .prev('.panel-heading')
        .find("i.indicator")
        .toggleClass('fa-chevron-down fa-chevron-right');
	};
	
	$('[data-toggle="popover"]').popover({html:true});
		
	$(document).on("focus", "[data-behaviour~='datepicker']", function(e){
    $(this).datepicker({
    		dateFormat: 'dd-mm-yy',
    		autoclose: true,
    		todayBtn: true,
    		clearBtn: true,
    		calendarWeeks: true,
    		todayHighlight: true,
    		changeYear: true,
    		changeMonth: true
    		});
    });
    
   	$('#accordion').on('hidden.bs.collapse', toggleChevron);
	$('#accordion').on('shown.bs.collapse', toggleChevron); 
	

});


$(document).on('nested:fieldAdded', function(event){
  // this field was just inserted into your form
  var field = event.field; 
  // it's a jQuery object already! Now you can find date input
  var dateField = field.find('.date');
  // and activate datepicker on it
  dateField.datepicker();
$(".select2-select").select2({
    theme: "bootstrap",
    tag: true,
    placeholder: "Select",
    tokenSeparators: [',', ' '],
    allowClear: true
});
});
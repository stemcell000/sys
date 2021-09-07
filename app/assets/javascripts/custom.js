
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
	
	$('[data-toggle="popover"]').popover({html:true});
  $('#accordion').on('hidden.bs.collapse', toggleChevron);
  $('#accordion').on('shown.bs.collapse', toggleChevron); 
});
		
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

function getContainerMap(id, containername) {
console.log("Selected");
console.log("ID : "+id);
param = {container_id: id}; 
console.log("param : "+id);
$("#map-shelf-rack").html("");
  $.ajax({
      url : '/containers/map_container',
      data: param,
      success: function(data){
        console.log("success");
        },
      //error: function(data) { alert("error"); }
      });
    $(containername).attr({'data-id': id});
}


function getShelfRackMap(id, shelfrackname) {
console.log("Selected");
console.log("ID : "+id);
param = {shelf_rack_id: id}; 
console.log("param : "+param);
  $.ajax({
      url : '/shelf_racks/map_shelf_rack',
      data: param,
      success: function(data) {
        console.log("success");
        },
      error: function(data) { alert("error"); }
      });
}

function getBoxMap(id, containername) {
console.log("Selected");
console.log("Box ID : "+id);
param = {box_id: id}; 
  $.ajax({
      url : '/vials/map_tube',
      data: param,
      success: function(data){
        console.log("success");
        },
      //error: function(data) { alert("error"); }
      });
    $(containername).attr({'data-id': id});
}

function updateBox(id, param){
  $.ajax({
      url : '/vials/'+id+'/update_box',
      type: 'patch',
      data: param,
      success: function(data){
        console.log("updateBox success")
        },
      error: function(data) { 
        console.log("error")
        },
      })
}

    //Drag and Drop
function updateShelfRack(id, param){
  $.ajax({
      url : '/boxes/'+id+'/update_shelf_rack',
      type: 'patch',
      data: param,
      success: function(data){
        console.log("success")
        },
      error: function(data) { 
        console.log("error")
        },
      })
}

function reset_fields(){
  $("#map-container").html("");
$("#container-map-container").html("");
$("#map-shelf-rack").html("");  
}

//Activation des chevron sur le bootstrap panel collapse
function toggleChevron(e) {
    $(e.target)
        .prev('.panel-heading')
        .find("i.indicator")
        .toggleClass('fa-chevron-down fa-chevron-right');
  };

$(document).on("turbolinks:load", () => {
    $(".select2-select").select2({
        theme: "bootstrap",
        tag: true,
        placeholder: "Select",
        tokenSeparators: [',', ' '],
        allowClear: true
    });
})

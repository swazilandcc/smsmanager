# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $("#competition_start_date").datepicker
    minDate: 0
    maxDate: "+30D"
    numberOfMonths: 1
    dateFormat: "yy-mm-dd"
    onSelect: (selected) ->
      $("#competition_end_date").datepicker "option", "minDate", selected

  $("#competition_end_date").datepicker
    minDate: 0
    maxDate: "+30D"
    numberOfMonths: 1
    dateFormat: "yy-mm-dd"
    onSelect: (selected) ->
      $("#competition_start_date").datepicker "option", "maxDate", selected

#  $("#competition_start_date").datepicker
#    numberOfMonths: 1
#    onSelect: (selected) ->
#      $("#competition_end_date").datepicker "option", "minDate", selected
#
#  $("#competition_end_date").datepicker
#    numberOfMonths: 1
#    onSelect: (selected) ->
#      $("#competition_start_date").datepicker "option", "maxDate", selected


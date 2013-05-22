# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#send_bulk_message_group_id').chosen()

  $('#send_bulk_message_message_template').change ->
    message_template_id = $(this).find(":selected").val();

    jQuery.ajax
      type: "POST"
      url: "/bulk_message_templates/getMessage"
      data: JSON.stringify({'message_template_id':message_template_id})
      success:
        (data) ->
          $('#send_bulk_message_message').val(data.message_template.message)
      dataType: "json"
      contentType: "application/json"


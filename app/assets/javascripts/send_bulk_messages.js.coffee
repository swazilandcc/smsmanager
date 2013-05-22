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

  $('#send_bulk_message_group_id').change ->
    groupid = $(this).find(":selected").val();

    #make ajax request to retrive all contacts in group
    i = 0

    jQuery.ajax
      type: "POST"
      url: "/send_bulk_messages/getContacts"
      data: JSON.stringify({'groupID':groupid})
      success:
        (data) ->
          $('#groupContacts').html("<b>Contacts Found In Group<br /></b>")
          while i < data.contacts.length
            console.log(data.contacts[i].first_name)
            $('#groupContacts').append(data.contacts[i].first_name + " " + data.contacts[i].last_name + " -> " + data.contacts[i].cell_number + "<br />")
            i++
      dataType: "json"
      contentType: "application/json"



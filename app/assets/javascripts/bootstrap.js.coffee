jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()

  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  #BulkSMS Generation Area
  $('#rptFltr').hide()

  $('#genReport').click ->
      dateTo = new Date($("#to").val())
      dateFrom = new Date($("#from").val())

      dateFromQry = dateFrom.getFullYear() + "-" + (dateFrom.getMonth() + 1) + "-" + dateFrom.getDate()
      dateToQry = dateTo.getFullYear() + "-" + (dateTo.getMonth() + 1) + "-" + dateTo.getDate()

      console.log(dateFromQry + " " + dateToQry)

      if dateTo >= dateFrom

        i = 0

        jQuery.ajax
          type: "POST"
          url: "/dashboard/getBulkSMSReport"
          data: JSON.stringify({'start_date': dateFromQry, 'end_date': dateToQry})
          success:
            (data) ->
              rptTable = "<h4>Bulk SMS Report For Date From <b>" + dateFromQry + "</b> To <b>" + dateToQry + "</b><br /><br />"
              rptTable = "<a href='/dashboard/downloadBulkSMSReport?dateFrom=" + dateFromQry + "&dateTo=" + dateToQry + "' class='btn btn-info'>Export to Excel</a><br /><br />"
              rptTable += "<table class='table table-bordered'><thead><tr><th>Cell Number</th><th>Send Date & Time</th><th>Sent By</th></tr></thead><tbody>"
              while i < data.results.length
                rptTable += "<tr>"
                rptTable += "<td>" + data.results[i].cell_number + "</td>"
                rptTable += "<td>" + data.results[i].send_date + "</td>"
                rptTable += "<td>" + data.results[i].user_id + "</td>"
                rptTable += "</tr>"
                i++
              rptTable += "</tbody></table>"
              $('#reportResult').html(rptTable)
              $('#ResultCount').html("Total Number of SMS Sent for Selected Period: <b>" + data.results.length + "</b>").addClass("alert")

          dataType: "json"
          contentType: "application/json"

      else
        $("#errorMessage").html("From date must be greater than to date, please try again").style("color:red")

        event.preventDefault()


  today_date = new Date()
  int_d = new Date(today_date.getFullYear(), today_date.getMonth() + 1, 1)
  month_start = new Date(today_date.getFullYear(), today_date.getMonth(), 1)
  month_end = new Date(int_d - 1)

  $("#from").datepicker(dateFormat: "yy-mm-dd").datepicker("setDate", month_start)
  $("#to").datepicker(dateFormat: "yy-mm-dd").datepicker("setDate", month_end)


// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.datepicker
//= require chosen-jquery
//= require rails.validations
//= require rails.validations.simple_form
//= require twitter/bootstrap
//= require_tree .

google.load("visualization", "1", {packages:["corechart"]});
google.setOnLoadCallback(drawChart);

function drawChart() {

    if(document.getElementById("chart_div")){


        var jsonData = $.ajax({
            url: "/dashboard/fhLoad",
            dataType:"json",
            type: 'POST',
            async: false
        }).responseText;

        // Create our data table out of JSON data loaded from server.
        var data = new google.visualization.DataTable(jsonData);

        new google.visualization.ColumnChart(document.getElementById('chart_div')).
            draw(data, {curveType: "function",
                width: 900, height: 500,
                title: 'Total Number of SMS Received Per Hour',
                vAxis: {maxValue: 100, minValue: 0}}
        );

    }else{

        console.log("0nlyD4ashB0ard")

    }


}


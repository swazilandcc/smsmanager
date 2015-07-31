class DashboardController < ApplicationController

  def index
    #default homepage for SMS Manager
    @contact_count = Contact.all.count()
    @group_count = Group.all.count()
    @bulk_message_template_count = BulkMessageTemplate.all.count()
    @incoming_messages_today = IncomingMessage.all(:conditions => "created_at BETWEEN '#{Time.now.strftime("%Y-%m-%d")} 00:00:00' AND '#{Time.now.strftime("%Y-%m-%d")} 23:59:59'").count()
    @incoming_messages_this_month = IncomingMessage.all(:conditions => "created_at BETWEEN '#{Time.now.strftime("%Y-%m")}-01 00:00:00' AND '#{Time.now.strftime("%Y-%m")}-31 23:59:59'").count()
    @active_competitions = Competition.find_all_by_active(true)

    @outgoing_messages_today = SmsLog.all(:conditions => "created_at BETWEEN '#{Time.now.strftime("%Y-%m-%d")} 00:00:00' AND '#{Time.now.strftime("%Y-%m-%d")} 23:59:59'").count()
    @outgoing_messages_this_month = SmsLog.all(:conditions => "created_at BETWEEN '#{Time.now.strftime("%Y-%m")}-01 00:00:00' AND '#{Time.now.strftime("%Y-%m")}-31 23:59:59'").count()
  end

  def fhLoad

         @check_load = IncomingMessage.find_by_sql(%q{SELECT h.theHour
     , COUNT(sender) AS sms
  FROM ( SELECT 0 AS theHour
         UNION ALL SELECT 1
         UNION ALL SELECT 2
         UNION ALL SELECT 3
         UNION ALL SELECT 4
         UNION ALL SELECT 5
         UNION ALL SELECT 6
         UNION ALL SELECT 7
         UNION ALL SELECT 8
         UNION ALL SELECT 9
         UNION ALL SELECT 10
         UNION ALL SELECT 11
         UNION ALL SELECT 12
         UNION ALL SELECT 13
         UNION ALL SELECT 14
         UNION ALL SELECT 15
         UNION ALL SELECT 16
         UNION ALL SELECT 17
         UNION ALL SELECT 18
         UNION ALL SELECT 19
         UNION ALL SELECT 20
         UNION ALL SELECT 21
         UNION ALL SELECT 22
         UNION ALL SELECT 23) AS h
  LEFT OUTER
    JOIN incoming_messages
      ON EXTRACT(HOUR FROM DATE_FORMAT(created_at, "%H:%I")) = h.theHour
     AND DATE(created_at) = DATE_FORMAT(NOW(), "%Y-%m-%d")
  GROUP
    BY h.theHour})

      @graphCols = {cols: [{"id" => "","label" => "Hours","pattern" => "","type" =>"string"}, {"id" => "","label" => "Total # SMSes","pattern" => "","type" =>"number"}], rows: []}

      @check_load.each do |x|

        @graphCols[:rows] << {"c" => [{"v" => x.theHour.to_s + ":00"}, {"v" => x.sms}]}

      end

      respond_to do |format|

        format.json { render json: @graphCols }

      end


  end

  def bulksms_report



  end

  def incomingsms_report


  end

  def downloadBulkSMSReport

    @start_date = params[:dateFrom] rescue nil
    @end_date = params[:dateTo] rescue nil

    @results_fixed = []

    respond_to do |format|

      if @start_date.nil? == false && @end_date.nil? == false

        @sms_report = SmsLog.all(:conditions => "created_at BETWEEN '#{@start_date} 00:00' AND '#{@end_date} 23:59'")

        @sms_report.each do |sms|

          @results_fixed << {cell_number: "#{sms.cell_number}", send_date: "#{sms.created_at.strftime("%d-%m-%Y %H:%I")}", user_id: "#{User.find(sms.user_id).first_name.to_s + " " + User.find(sms.user_id).last_name.to_s }" }

        end

        format.html do

          csv_string = CSV.generate do |csv|
            # header row
            csv << ["cell_number", "send_date", "sent_by"]
            # data rows
            @sms_report.each do |sms|
              csv << [sms.cell_number, sms.created_at.strftime("%d-%m-%Y %H:%M"), User.find(sms.user_id).first_name.to_s + " " + User.find(sms.user_id).last_name.to_s]
            end
          end



          # send it to the browser
          send_data csv_string,
                    :type => 'text/csv; charset=iso-8859-1; header=present',
                    :disposition => "attachment; filename=bulksms_report_#{@start_date}_#{@end_date}.csv"


        end


      else

          format.js { render js: "alert('Unable to Generate Report! Please check all required fields are entered')"}

      end

    end

  end

  def import_contact
    @contact = Contact.new
    @contact.cell_number = params[:cell_number]
    respond_to do |format|
      format.js
    end
  end

  def downloadIncomingSMSReport
    @start_date = params[:dateFrom] rescue nil
    @end_date = params[:dateTo] rescue nil

    @results_fixed = []

    respond_to do |format|

      if @start_date.nil? == false && @end_date.nil? == false

        @sms_report = IncomingMessage.all(:conditions => "reply_sent_date_time BETWEEN '#{@start_date} 00:00' AND '#{@end_date} 23:59'")

        format.html do

          csv_string = CSV.generate do |csv|
            # header row
            csv << ["cell_number", "keyword", "option", "extra_text" "send_date"]
            # data rows
            @sms_report.each do |sms|
              csv << [sms.sender, sms.keyword, sms.option, sms.extra_text, sms.reply_sent_date_time.strftime("%d-%m-%Y %H:%M")]
            end
          end

          # send it to the browser
          send_data csv_string,
                    :type => 'text/csv; charset=iso-8859-1; header=present',
                    :disposition => "attachment; filename=incomingsms_report_#{@start_date}_#{@end_date}.csv"

        end

      else

        format.js { render js: "alert('Unable to Generate Report! Please check all required fields are entered')"}

      end

    end

  end

  def getIncomingMessageReport

    @start_date = params[:start_date] rescue nil
    @end_date = params[:end_date] rescue nil

    @results_fixed = []

    respond_to do |format|

      if @start_date.nil? == false && @end_date.nil? == false

        @sms_report = IncomingMessage.all(:conditions => "reply_sent_date_time BETWEEN '#{@start_date} 00:00' AND '#{@end_date} 23:59'")

        @sms_report.each do |sms|

          @results_fixed << {cell_number: "#{sms.sender}", send_date: "#{sms.reply_sent_date_time.strftime("%d-%m-%Y %H:%I")}", keyword: "#{sms.keyword}", option: "#{sms.option}", extra_text: "#{sms.extra_text}", short_code: "#{sms.short_code}"}

        end

        format.json { render json: {:results => @results_fixed}}
      else

        format.js { render js: "alert('Unable to Generate Report! Please check all required fields are entered')"}

      end

    end

  end


  def getBulkSMSReport

    @start_date = params[:start_date] rescue nil
    @end_date = params[:end_date] rescue nil

    @results_fixed = []

    respond_to do |format|

      if @start_date.nil? == false && @end_date.nil? == false

        @sms_report = SmsLog.all(:conditions => "created_at BETWEEN '#{@start_date} 00:00' AND '#{@end_date} 23:59'")

        @sms_report.each do |sms|

          @results_fixed << {cell_number: "#{sms.cell_number}", send_date: "#{sms.created_at.strftime("%d-%m-%Y %H:%I")}", user_id: "#{User.find(sms.user_id).first_name.to_s + " " + User.find(sms.user_id).last_name.to_s }" }

        end

        format.json { render json: {:results => @results_fixed}}

      else

        format.js { render js: "alert('Unable to Generate Report! Please check all required fields are entered')"}

      end

    end

  end

end
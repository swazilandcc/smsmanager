class DashboardController < ApplicationController
  before_filter :authenticate_user!

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
      ON EXTRACT(HOUR FROM DATE_FORMAT(created_at, "%H:%i")) = h.theHour
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

end
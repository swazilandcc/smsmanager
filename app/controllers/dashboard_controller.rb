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

end
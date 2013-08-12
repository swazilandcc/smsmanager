class SendSMS < SqlBox

  self.table_name = "send_sms"
  self.primary_key = "sql_id"

  attr_accessible :momt, :sender, :receiver, :msgdata, :sms_type


end
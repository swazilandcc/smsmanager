class SqlBox < ActiveRecord::Base

  # Connect to external radius database
  self.abstract_class = true
  self.inheritance_column = "activerecordtype"
  establish_connection(:sms_router)


end
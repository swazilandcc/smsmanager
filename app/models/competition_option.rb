class CompetitionOption < ActiveRecord::Base
  attr_accessible :competition_id, :option_name, :option_number
  belongs_to :competition
end

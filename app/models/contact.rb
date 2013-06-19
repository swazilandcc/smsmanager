class Contact < ActiveRecord::Base
  attr_accessible :cell_number, :first_name, :last_name, :title, :group_ids, :church, :region_id

  validates_presence_of [:first_name, :last_name, :cell_number]
  validates_uniqueness_of :cell_number

  belongs_to :region

  has_many :contacts_groups, :dependent => :delete_all
  has_many :groups, :through => :contacts_groups, :dependent => :delete_all

  def full_name

    return self.title + self.first_name + " " + self.last_name + " - " + self.cell_number

  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |contact|
        csv << contact.attributes.values_at(*column_names)
      end
    end
  end



end

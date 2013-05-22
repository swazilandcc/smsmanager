class Group < ActiveRecord::Base
  attr_accessible :description, :name

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :contacts_groups, :dependent => :delete_all
  has_many :contacts, :through => :contacts_groups, :dependent => :delete_all

end

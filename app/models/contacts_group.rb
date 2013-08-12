class ContactsGroup < ActiveRecord::Base
  attr_accessible :contact_id, :group_id

  belongs_to :contact
  belongs_to :group

  def get_contacts(gid)

    ContactsGroup.find_all_by_group_id(gid).each do |x|

      return x.contact.full_name

    end

  end

end

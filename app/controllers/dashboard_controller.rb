class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    #default homepage for SMS Manager

  end

end
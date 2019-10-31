class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :set_stats

  def index
  end

  private

  def set_stats
    @parsers = current_user.parsers
    @documents = current_user.documents
  end
end

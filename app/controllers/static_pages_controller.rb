class StaticPagesController < ApplicationController
  before_action :logged_in_user
  def home
    @user = current_user
  end
end

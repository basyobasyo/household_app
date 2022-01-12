class PaymentsController < ApplicationController
  def index
    @user = User.all
    user = User.find(current_user.id)
  end
end

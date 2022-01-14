class PaymentsController < ApplicationController
  def index
  end

  def follow
    @follow_id  = params[:follow_id]
    @another_id = params[:another_id]
    User.follow(@follow_id, @another_id)
    redirect_to root_path
  end
end

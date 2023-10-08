class Api::V1::SessionsController < BaseController
  include Devise::Controllers::Rememberable

  def create
    super do |user|
      user.remember_me! if params[:remember_me] == '1'
    end
  end

  def destroy
    super do |user|
      user.forget_me!
  end

end
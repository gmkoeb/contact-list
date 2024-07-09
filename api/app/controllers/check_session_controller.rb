class CheckSessionController < ApplicationController
  before_action :authenticate_user

  def check
    render status: :ok, json: { session: 'Authorized' }
  end
end

require 'leads_client'

class CallbacksController < ApplicationController
  

  def create
    LeadsClient.enqueue(callback_request_params)
    redirect_to :success
  end

  private

  FORM_FIELDS = %i[name business_name telephone email]
  def callback_request_params
    params.require(:callback_request).permit(FORM_FIELDS)
  end
end
require 'leads_client'

class CallbacksController < ApplicationController
  
  def new
    @callback_request = CallbackRequest.new
    @errors ||= []
  end

  def create
    response = LeadsClient.enqueue(callback_request_params)
    if response.success?
      redirect_to :success
    else
      @callback_request = CallbackRequest.new(callback_request_params)
      @errors = response.errors
      render :new
    end
  end

  private

  FORM_FIELDS = %i[name business_name telephone_number email]
  def callback_request_params
    params.require(:callback_request).permit(FORM_FIELDS)
  end

end
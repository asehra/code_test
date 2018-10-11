module LeadsClient
  ENQUEUE_ENDPOINT = "#{ENV.fetch('LEAD_API_URI')}/api/v1/create"

  DEFAULT_PARAMS = {
    "access_token" => ENV['LEAD_API_ACCESS_TOKEN'],
    "pGUID" => ENV['LEAD_API_PGUID'],
    "pAccName" => ENV['LEAD_API_PACCNAME'],
    "pPartner" => ENV['LEAD_API_PPARTNER']
  }

  def self.enqueue(form_data)
    lead = DEFAULT_PARAMS.merge(form_data.to_h)
    response = Net::HTTP.post_form(URI(ENQUEUE_ENDPOINT), lead)
    errors = JSON(response.body).fetch('errors', [])
    EnqueueResponse.new(success: response.code == '201', errors: errors)
  rescue SocketError, Errno::ECONNREFUSED
    EnqueueResponse.new(success: false, errors: [CONNECTION_FAILED])
  end

  CONNECTION_FAILED = 'Unable to register interest. Please try after some time'
end

class EnqueueResponse
  attr_reader :errors
  def initialize(success:,errors:[])
    @success = success
    @errors = errors
  end

  def success?
    !!@success
  end
end

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
    Net::HTTP.post_form(URI(ENQUEUE_ENDPOINT), lead)
  end
end
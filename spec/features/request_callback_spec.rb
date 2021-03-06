require "rails_helper"

RSpec.feature "Request a callback", :type => :feature do
  let(:leads_endpoint) { "#{ENV['LEAD_API_URI']}/api/v1/create" }

  scenario "User successfully requests a callback" do    
    visit "/callback/new"

    fill_in "Name", with: "John Doe"
    fill_in "Business name", with: 'Prospective Ltd'
    fill_in "Email", with: 'john@prospectiveltd.com'
    fill_in "Telephone number", with: '02085555555'

    VCR.use_cassette("Successful") do
      click_button "Request Callback"
    end

    expect(WebMock).to have_requested(:post, leads_endpoint)
      .with(body: {
        "access_token" => ENV['LEAD_API_ACCESS_TOKEN'],
        "pGUID" => ENV['LEAD_API_PGUID'],
        "pAccName" => ENV['LEAD_API_PACCNAME'],
        "pPartner" => ENV['LEAD_API_PPARTNER'],
        "name" => "John Doe", 
        "business_name" => "Prospective Ltd",
        "email" => "john@prospectiveltd.com",
        "telephone_number" => "02085555555"
      },
        headers: {'Content-Type' => 'application/x-www-form-urlencoded'})
    expect(page).to have_text("Thanks for the request. We will get back to you within next 3 working days.")
  end

  scenario "User enters bad data" do
    visit "/callback/new"

    fill_in "Name", with: "John Doe"
    fill_in "Business name", with: 'Prospective Ltd'
    fill_in "Email", with: 'john@prospectiveltd.com'
    fill_in "Telephone number", with: '0208555'

    VCR.use_cassette("TelephoneNumberInvalid") do
      click_button "Request Callback"
    end

    expect(page).to have_text("Field 'telephone_number' wrong format (must contain have valid phone number with 11 numbers. string max 13 chars)")
  end
end
require "rails_helper"

RSpec.feature "Request a callback", :type => :feature do
  scenario "User successfully requests a callback" do
    visit "/callback/new"

    fill_in "Name", :with => "John Doe"
    click_button "Request Callback"

    expect(page).to have_text("Thanks for the request. We will get back to you within next 3 working days.")
  end
end
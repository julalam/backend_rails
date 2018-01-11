class CountriesController < ApplicationController
  countries = Country.order(:id)

  render status: :ok, json: countries
end

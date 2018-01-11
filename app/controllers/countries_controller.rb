class CountriesController < ApplicationController
  def index
    countries = Country.order(:id)

    render status: :ok, json: countries
  end
end

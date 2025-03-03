class PostcodeLookupsController < ApplicationController
  skip_load_and_authorize_resource

  def new
    response = HTTParty.get(
      "https://api.postcodes.io/postcodes/#{params[:postcode].gsub(" ", "")}",
      headers: { "Content-Type" => "application/json" }
    )

    if response.success?
      render json: response.parsed_response
    else
      render json: { error: 'Postcode not found' }, status: :not_found
    end
  end
end
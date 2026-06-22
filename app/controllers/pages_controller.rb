class PagesController < ApplicationController
  def home
  end

  def health
    render json: { status: "OK", timestamp: Time.now.utc }
  end

  def version
    render json: { version: "1.0.0", environment: Rails.env }
  end
end

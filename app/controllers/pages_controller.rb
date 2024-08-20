class PagesController < ApplicationController
  def home
    render json: { message: 'Welcome to the E-commerce Shop API!' }
  end
end

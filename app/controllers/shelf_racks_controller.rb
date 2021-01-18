class ShelfRacksController < ApplicationController
  def index
    @racks = Rack.all
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

private

    def shelf_rack_params
      params.require(:shelf_rack).permit()
    end
end

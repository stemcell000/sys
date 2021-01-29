class ShelfRacksController < ApplicationController
  before_action :set_shelf_rack, only: [:edit, :update]
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

  def map_shelf_rack
    set_shelf_rack_map
    respond_to do |format|
      format.js
    end
  end

private

    def shelf_rack_params
      params.require(:shelf_rack).permit(:id, :shelf_id, 
        rack_positions_attributes[:id, :name, :available])
    end

    def set_shelf_rack
      @shelf_rack = Rack.find(params[:id])
    end

    def set_shelf_rack_map
      @boxes = Box.where(rack_position_id: nil).order(:name)
      @arr = @boxes.each_slice(2).to_a

      if params[:shelf_rack_id]
        @shelf_rack = ShelfRack.find(params[:shelf_rack_id])

        @position_ids = @shelf_rack.rack_position_ids
        @position_box_names = @shelf_rack.rack_positions.map{|p| p.box.nil? ? "":p.box.name}
        @position_box_ids = @shelf_rack.rack_positions.order(:nb).map{|p| p.box.nil? ? "":p.box.id}
        @position_box_color_codes = @shelf_rack.rack_positions.map{|p| p.box.nil? ? "":p.box.color.code}
      end
    end

end

class ContainerTypeController < ApplicationController
	def index
    @shelves = Shelf.all
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

  def map_container
  set_container_map
  respond_to do |format|
    format.js
  end
end

  private
    def container_type_params
      params.require(:vial).permit(:id, :name)
    end

    def set_rack_map

    end
end

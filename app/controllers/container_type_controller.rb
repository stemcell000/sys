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

  private
    def container_type_params
      params.require(:vial).permit(:id, :name)
end

class ShelvesController < ApplicationController
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

  def generate_racks
    i=0
    self.rack_number.times{
      self.shelf_racks.create(name: i.to_s)
      i+=1
    }
  end

  private

  def shelf_params
    params.require(:shelf).permit( :id, :shelf_rack_number, :shelf_id)
end

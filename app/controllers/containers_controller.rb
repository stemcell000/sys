class ContainersController < InheritedResources::Base
  
    #Smart_listing
    include SmartListing::Helper::ControllerExtensions
    helper  SmartListing::Helper
    
    before_action :set_container, only:[:delete, :edit, :show, :update, :destroy, :set_container_map]
  
  def index
    @q = Container.ransack(params[:q])
     @containers = @q.result(distinct: true)
     @containers = @containers.includes(:shelves).order(:name)
  end
  
  def new
     @container = Container.new
  end
 
  def create
     @container = Container.create(container_params)
     if  @container.valid?
       flash.keep[:success] = "Container created !"
       redirect_to @container
     else
       render action: "new"
     end
  end
  
  def edit
    
  end
  
  def update
      @container.update_attributes(container_params)
   if @container.valid?
     flash.keep[:success] = "Container updated!"
     redirect_to container_path 
   else
      render :action => 'edit'
   end
  end

  def destroy
    @container.destroy
    redirect_to containers_path
  end

  def show
    @container_type_id = @container.container_type_id
  end

  def map_container
    set_container_map
    respond_to do |format|
      format.js
    end
  end

  def fetch_vials
  @box = Box.find(params[:id])
  set_variables
    @vials = Vial.where(position_id: @position_ids)
    @vials = smart_listing_create(:vials, @vials, partial: "vials/smart_listing/list", default_sort: {name: "asc"}, page_sizes: [20, 30, 50, 100])
  end
  
  private

  def container_params
    params.require(:container).permit(:id, :name, :barcode, :location_id, :container_type_id, :recap,
    location_attributes: [:id, :name, :building_id],
    container_type_attributes: [:id, :name],
    shelf_ids: [],
    shelves_attributes: [:id, :name, :barcode, :rack_number, :rack_position_number, :container_id, :_destroy,
      shelf_racks_attributes: [:id, :name, :shelf_id, :_destroy]])
  end
  
  def set_container
    @container = Container.find(params[:id])
  end

  def set_container_map
      @boxes = Box.where(rack_position_id: nil).order(:name)
      @arr = @boxes.each_slice(5).to_a

        begin
          @container = Container.find(params[:container_id])
        rescue ActiveRecord::RecordNotFound => e
          print e
        end
  end
  
end


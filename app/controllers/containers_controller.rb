class ContainersController < InheritedResources::Base
  
    #Smart_listing
    include SmartListing::Helper::ControllerExtensions
    helper  SmartListing::Helper
    
    before_action :set_container, only:[:delete, :edit, :show, :update, :destroy]
  
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
  
end


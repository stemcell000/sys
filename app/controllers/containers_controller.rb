class ContainersController < InheritedResources::Base
  
    #Smart_listing
    include SmartListing::Helper::ControllerExtensions
    helper  SmartListing::Helper
    
    before_action :set_container, only:[:delete, :edit, :show, :update, :destroy]
  
  def index
    @q = Container.ransack(params[:q])
     @containers = @q.result(distinct: true)
     @containers = @containers.includes(:shelves).order(:name)
     #@containers = smart_listing_create(:containers, @containers, partial: "containers/smart_listing/list", default_sort: {name: "desc"}, page_sizes: [10, 20, 30, 50, 100])
  end
  
  def new
     @container = Container.new
  end
 
  def create
     @container = Container.create(container_params)
     if  @container.valid?
       flash.keep[:success] = "Container created !"
       @container.generate_recap
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
    
  end
  
  private

  def container_params
    params.require(:container).permit(:id, :name, :barcode, :location_id, :recap,
    location_attributes: [:id, :name],
    shelves_ids: [],
    shelf_attributes: [:id, :name, :barcode])
  end
  
  def set_container
    @container = Container.find(params[:id])
  end
  
end


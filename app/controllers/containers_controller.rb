class ContainersController < InheritedResources::Base
    
    before_action :set_container, only:[:delete, :edit, :show, :update, :destroy, :set_container_map]
    before_action :set_variables, only: [:fetch_box]
  
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
   @position_ids = @box.positions.order(:nb).pluck(:id)
   @vial=Vial.where(position_id: @position_ids)
  end

  def fetch_box
    
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
      @boxes = Box.without_rack_postion.order(:name)
      @arr = @boxes.each_slice(5).to_a

        begin
          @container = Container.find(params[:container_id])
        rescue ActiveRecord::RecordNotFound => e
          print e
        end
  end

  def set_variables
    @box = Box.find(params[:id])
    if @box.box_type
      @box_type = @box.box_type
      @v_max = @box_type.vertical_max
      @h_max = @box_type.horizontal_max
      @position_ids = @box.positions.order(:nb).pluck(:id)
      @position_names = @box.positions.order(:nb).map{|p|(p.nb+1).to_s}
      @position_batch_names = @box.positions.order(:nb).map{|p| p.vial.nil? ? "":p.vial.name}
      @position_batch_names_slots = @box.positions.order(:nb).map{|p| p.vial.nil? ? "":p.vial.name.truncate(6)}
      @position_batch_ids = @box.positions.order(:nb).map{|p| p.vial.nil? ? "":p.vial.id}
      @position_batch_volumes  = @box.positions.order(:nb).map{|p| p.vial.nil? ? "-" : "#{p.vial.volume}"}
      @position_batch_bcs  = @box.positions.order(:nb).map{|p| p.vial.nil? ? "-" : "#{p.vial.barcode}"}
      @position_batch_freez  = @box.positions.order(:nb).map{|p| p.vial.nil? ? "-" : "#{p.vial.freezing_date}"}
      @position_batch_cmts = @box.positions.order(:nb).map{|p| p.vial.nil? ? "-" : "#{p.vial.comment}"}
      @position_batch_recaps = @box.positions.order(:nb).map{|p| p.vial.nil? ? "-" :"#{p.vial.recap}"}
    else
      @v_max = 0
      @h_max = 0
      @position_ids = []
      @position_names = []
    end
        @vials=@box.vials.order(name: :asc)
  end
end


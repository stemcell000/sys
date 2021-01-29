class BoxesController < InheritedResources::Base
       
    #Smart_listing
    include SmartListing::Helper::ControllerExtensions
    helper  SmartListing::Helper
    
    before_action :set_box, only:[:delete, :edit, :show, :update]
  
def index
     @q = Box.ransack(params[:q])
      
     @boxes = @q.result(distinct: true)
     
     if params[:q].blank?
      @vials = Vial.all  
     else
      positions = Position.where(box_id: @boxes.pluck(:id)) 
      @vials = Vial.where(position_id: positions.pluck(:id))
     end
      @boxes = @boxes.includes(:positions, :rack_position).order(:name)

      @boxes = @boxes.where(rack_position_id: RackPosition.all.pluck(:id)) 
      
      @vials = smart_listing_create(:vials, @vials, partial: "vials/smart_listing/list", default_sort: {id: "asc"}, page_sizes: [10, 20, 30, 50, 100])
      @boxes = smart_listing_create(:boxes, @boxes, partial: "boxes/smart_listing/list", default_sort: {name: "desc"}, page_sizes: [10, 20, 30, 50, 100])
end

def box_inventory
 @q = Box.ransack(params[:q])
 @boxes = @q.result(distinct: true).order(:name).page(params[:page]).per(20)
 @boxes = smart_listing_create(:boxes, @boxes, partial: "boxes/smart_listing/list", default_sort: {name: "desc"}, page_sizes: [20, 30, 50, 100])  
end

def destroy
 @box.destroy
 redirect_to boxes_path
end

def fetch_vials
  @box = Box.find(params[:id])
  set_variables
    @vials = Vial.where(position_id: @position_ids)
    @vials = smart_listing_create(:vials, @vials, partial: "vials/smart_listing/list", default_sort: {name: "asc"}, page_sizes: [20, 30, 50, 100])
end

def fetch_position
  @vial = Vial.find(params[:vial_id])
  @box = Box.find(params[:box_id])
  set_variables
    @vials = Vial.where(position_id: @position_ids)
    @vials = smart_listing_create(:vials, @vials, partial: "vials/smart_listing/list", default_sort: {id: "asc"}, page_sizes: [20, 30, 50, 100])
    
end
 
def new
  @box = Box.new
end

def create
   @box = Box.create(box_params)
   if  @box.valid?
     flash.keep[:success] = "Box created !"
     @box.generate_positions
     redirect_to boxes_path
   else
     render action: "new"
   end
end

def edit
  
end

def update
    @box.update_attributes(box_params)
     if @box.valid?
       flash.keep[:success] = "Task completed!"
       redirect_to boxes_path
    else
        render :action => 'edit'
    end
end

def show
  
end

def sorter
   set_rack_map
 end
 
def map_box
  set_rack_map
  respond_to do |format|
    format.js
  end
end
  
def update_shelf_rack
  @box = Box.find(params[:box_id])
  if params[:rack_position_id]
    rack_position = RackPosition.find(params[:rack_position_id])
  else
    @box.update_columns(rack_position_id: nil)
  end
  #
  @box.rack_position = rack_position
  @box.save!
  set_rack_map
  #
  respond_to do |format|
    format.js
  end
end

def unsort
  @vial = Vial.find(params[:vial_id])
  @vial.position = position
  @vial.save!
end
 
private
    def box_params
      params.require(:box).permit(
        :name, :box_type_id, :barcode, :box_type_id,:comment, :rack_position_id,
        :container_name, :shelf_name, :shelf_rack_name, :recap, :color_id)
    end
    
    def set_box
      @box = Box.find(params[:id])
    end

    def set_rack_map
      @boxes = Box.where(rack_position_id: nil).order(:name)
      @arr = @boxes.each_slice(2).to_a
      if params[:shelf_rack_id]
        @shelf_rack = ShelfRack.find(params[:shelf_rack_id])
    
        @position_ids = @shelf_rack.rack_position_ids
        @position_names = @shelf_rack.rack_positions.map{|p| p.name.upcase}
        @position_box_names = @shelf_rack.rack_positions.map{|p| p.box.nil? ? "":p.box.name}
        @position_box_ids = @shelf_rack.rack_positions.order(:nb).map{|p| p.box.nil? ? "":p.box.id}
        @users = User.all
      end
    end

    def set_variables
      if @box.box_type
        @box_type = @box.box_type
        @v_max = @box_type.vertical_max
        @h_max = @box_type.horizontal_max
        @position_ids = @box.position_ids
        @position_names = @box.positions.map{|p|p.name.upcase()}
        @position_batch_names = @box.positions.map{|p| p.vial.nil? ? "":p.vial.name}
        @position_batch_ids = @box.positions.order(:nb).map{|p| p.vial.nil? ? "":p.vial.id}
      else
        @v_max = 0
        @h_max = 0
        @position_ids = []
        @position_names = []
      end
        #
        @storage_status= ""
        unless @box.rack_position_id.nil? 
            @storage_status = "stored in : " + @box.rack_position.shelf_rack.container.name+" | "+@box.rack_position.shelf_rack.name
        else
            @storage_status= "(unstored)"
        end
      end
    #
end


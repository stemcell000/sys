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
      @boxes = @boxes.includes(:positions).order(:name)
      @vials = smart_listing_create(:vials, @vials, partial: "vials/smart_listing/list", default_sort: {id: "asc"}, page_sizes: [20, 30, 50, 100])
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
  if @box.box_type
    @box_type = @box.box_type
    @v_max = @box_type.vertical_max
    @h_max = @box_type.horizontal_max
    @position_ids = @box.position_ids
    @position_names = @box.positions.map{|p|p.name.upcase()}
    @position_batch_names = @box.positions.map{|p| p.virus_batch.nil? ? "":p.virus_batch.name}
  else
    @v_max = 0
    @h_max = 0
    @position_ids = []
    @position_names = []
  end
    @vials = Vial.where(position_id: @position_ids)
    @vials = smart_listing_create(:vials, @vials, partial: "vials/smart_listing/list", default_sort: {name: "asc"}, page_sizes: [20, 30, 50, 100])
end

def fetch_position
  @vial = Vial.find(params[:virus_batch_id])
  @box = Box.find(params[:box_id])
if @box.box_type
    @box_type = @box.box_type
    @v_max = @box_type.vertical_max
    @h_max = @box_type.horizontal_max
    @position_ids = @box.position_ids
    @position_names = @box.positions.map{|p|p.name.upcase()}
    @position_batch_names = @box.positions.map{|p| p.virus_batch.nil? ? "":p.virus_batch.name}
  else
    @v_max = 0
    @h_max = 0
    @position_ids = []
    @position_names = []
  end
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
       redirect_to virus_productions_path 
    else
        render :action => 'edit'
    end
end

def show
  
end
 
private
    def box_params
      params.require(:box).permit(:name, :box_type_id, :barcode, :box_type_id, :shelf_id)
    end
    
    def set_box
      @box = Box.find(params[:id])
    end
end


class BoxesController < InheritedResources::Base
    
    before_action :set_box, only:[:delete, :edit, :show, :update, :set_variables]
  
def index
     @q = Box.ransack(params[:q])
     records = @q.result(distinct: true)
     box_ids = records.pluck(:id)
     
     if params[:q].blank?
      record_vials = Vial.all.order(:id)
     else
      positions = Position.where(box_id: box_ids) 
      record_vials = Vial.order(:id).where(position_id: positions.pluck(:id))
     end
      records = records.includes(:positions, :rack_position, :vials).order(:name)
      records = records.where(rack_position_id: RackPosition.all.pluck(:id)) 
      @pagy, @boxes = pagy(records, boxes: 10)
      @pagy_vials, @vials = pagy(record_vials.order(name: :asc), items: 15, page_param: :page_vial)
      @pagy_vials_count = @pagy_vials.count
end

def box_inventory
 @q = Box.ransack(params[:q])
 records = @q.result(distinct: true).order(:name)
 pagy, @boxes = pagy(records, boxes: 10)
end

def destroy
 @box.destroy
 redirect_to boxes_path
end

def fetch_vials
  @box = Box.find(params[:id])
  @q = @box.vials.ransack(params[:q])
  set_variables
  respond_to do |format|
    format.js
    format.html
  end
end

def fetch_position
  @vial = Vial.find(params[:vial_id])
  @box = Box.find(params[:box_id])
  @q = @box.vials.ransack(params[:q])
  set_variables
end

def fetch_box
  @box = Box.find(params[:id])
  @q = @box.vials.ransack(params[:q])
  set_variables
  respond_to do |format|
    format.js
    format.html
  end
end
 
def new
  @box = Box.new
end

def create
   @box = Box.create(box_params)
   if  @box.valid?
     flash.keep[:success] = "Box created !"
     @box.generate_positions
     redirect_to sorter_boxes_path
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
       redirect_to params[:source]
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
    #rack_position = RackPosition.find(params[:rack_position_id])
    @box.update_columns(rack_position_id: params[:rack_position_id])
   # @box.save!
  else
    @box.update_columns(rack_position_id: nil)
  end
  #
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
        :container_name, :shelf_name, :shelf_rack_name, :recap, :color_id, :team_id,
        team_attributes: [:name])
    end
    
    def set_box
      @box = Box.find(params[:id])
    end

    def set_rack_map
      @boxes = Box.without_rack_postion.order(:name)
      @arr = @boxes.each_slice(2).to_a
      if params[:shelf_rack_id]
        @shelf_rack = ShelfRack.find(params[:shelf_rack_id])
        @position_ids = @shelf_rack.rack_position_ids
        @position_names = @shelf_rack.rack_positions.map{|p| p.name.upcase}
        @position_box_names = @shelf_rack.rack_positions.map{|p| p.box.nil? ? "":p.box.name.truncate(10)}
        @position_box_ids = @shelf_rack.rack_positions.order(:nb).map{|p| p.box.nil? ? "":p.box.id}
        @users = User.all
      end
    end

    def set_variables
      @q = Box.ransack(params[:q])
      records = @q.result
      
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
      @pagy, @boxes = pagy(records.order(name: :asc), items: 10)
      vial_records=Vial.where(position_id: @position_ids)
      @pagy_vials, @vials = pagy(vial_records.order(name: :asc), items: 15, page_param: :page_vial, link_extra: 'data-remote="true"')
      @pagy_vials_count = @pagy_vials.count
        #
      if @box.rack_position
        @container = @box.rack_position.shelf_rack.shelf.container
        @storage_status= ""
        @storage_status = "stored in container " + @container.name+" / Rack : "+@box.rack_position.shelf_rack.name
      else
        @storage_status= "(unstored)"
      end
    end
    #
end


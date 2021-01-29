class VialsController < ApplicationController
  
      #Smart_listing
    include SmartListing::Helper::ControllerExtensions
    helper  SmartListing::Helper

def index
      #Formattage des dates
      start_time = params[:date_gteq].to_date rescue Date.current
      start_time = start_time.beginning_of_day # sets to 00:00:00
      end_time = params[:date_lteq].to_date rescue Date.current
      end_time = end_time.end_of_day # sets to 23:59:59
      #
      @q = Vial.ransack(params[:q])
      @q.sorts = ['name asc', 'date desc'] if @q.sorts.empty?
      @vials = @q.result
      @vials = smart_listing_create(:vials, @vials, partial: "vials/smart_listing/list", default_sort: {id: "asc"}, page_sizes: [20, 30, 50, 100])
      #
      vial_ids = @vials.map{|vb|vb.id}
      #
      @boxes = Box.joins(:vials).where(vials: {id: vial_ids})
      @boxes = @boxes.order(:name).page params[:page]
end
 
def new
  
end

def create
  
end

def update
  
end

def show
  
end

def new_from_inventory
    @vial = Vial.new
    @boxes = Box.where.not(:name => "Garbage")
end

def create_from_inventory
    @vial = Vial.create(vial_params)
    if  @vial.valid?
        @vial.generate_recap
        flash.keep[:success] = "Task completed!"
        @arr = @vials.each_slice(4).to_a
    else
        render :action => 'new_from_inventory'
    end
end

def edit_from_inventory

end

def update_from_inventory
  @vial.update_attributes(vial_params)
  
  if @vial.valid?
    @units = Unit.all
    @vial.generate_recap
    flash.keep[:success] = "Task completed!"
  else
    render :action => 'edit_from_inventory'
   end
end

def update_box
  position = Position.find(params[:position_id])
    if position.vial
      position.build_vial
    end
  @vial.position = position
  @vial.save!
  @box = Box.find(params[:box_id])
  @box_type = @box.box_type
  @v_max = @box_type.vertical_max
  @h_max = @box_type.horizontal_max
  @position_ids = @box.position_ids
  @position_names = @box.positions.map{|p|p.name.upcase()}
  @position_batch_names = @box.positions.map{|p| p.vial.nil? ? "":p.vial.name}
  @arr = @vials.each_slice(4).to_a
end

def destroy_from_inventory
    @vial.toggle!(:trash)
    if @vial.trash
      @vial.update_columns(:volume => 0)
      if @vial.position
        @vial.position.delete
       end
    end
   # redirect_to add_vb_from_inventory_virus_production_url(@virus_production.id)
 end
  
 def sorter
   set_unsorted_collection
 end
 
 def map_tube
   if params[:box_id]
      set_box_map
   end
    @users = User.all
     
  end
  
  #def update_box
  #@vial = Vial.find(params[:vial_id])    
   # if params[:position_id]
    #  position = Position.find(params[:position_id])
     # if position.vial
      #  position.build_vial
      #end
    #else
     # @vial.update_columns(:position_id => nil)
    #end
    #
   # @vial.position = position
    #@vial.save(validation: false)
    #
    #set_box_map
  #end
   
    def update_box
    position = Position.find(params[:position_id])
    @vial = Vial.find(params[:vial_id])
    @vial.position = position
    @vial.save!(validate: false)
    set_box_map
    #
    respond_to do |format|
      format.js
    end
  end
  
  private
    def vial_params
      params.require(:vial).permit(:id, :name, :barcode, :volume, :box_id,
                                   :position_id, :trash, :comment, :date,
                                   :description, :type_id, :barcode, :recap,
      :box_attributes =>[:id, :name, :barcode, :box_type_id, :shelf_id,
        :box_type_attributes =>[:id, :name],
        :shelf_attributes =>[:id, :name, :barcode, :container_id,
          :container_attributes => [:id, :name, :barcode, :location_id],
            :loaction_attrbutes => [:id, :name]]])
    end
    
    def set_objects
        @vial = Vial.find(params[:id])
    end

    def set_collections
      @vial = Vial.find(params[:id])
      @arr = @vials.each_slice(2).to_a
    end
    
    def set_unsorted_collection
     @vials = Vial.where(position_id: nil).order(:name)
      @arr = @vials.each_slice(2).to_a
    end

    def set_box_map
      @vials = Vial.where(position_id: nil).order(:name)
    if params[:box_id]
      @box = Box.find(params[:box_id])
      @box_type = @box.box_type
      @v_max = @box_type.vertical_max
      @h_max = @box_type.horizontal_max
      #
      @storage_status= ""
      unless @box.rack_position_id.nil? 
        @storage_status = "stored in : " + @box.rack_position.shelf_rack.container.name+" | "+@box.rack_position.shelf_rack.name
      else
        @storage_status= "(unstored)"
      end
      #
      @position_ids = @box.position_ids
      @position_names = @box.positions.map{|p| p.name.upcase}
      @position_batch_names = @box.positions.map{|p| p.vial.nil? ? "":p.vial.name}
      @position_batch_ids = @box.positions.order(:nb).map{|p| p.vial.nil? ? "":p.vial.id}
      @arr = @vials.each_slice(2).to_a
      @users = User.all
    end
  end
end

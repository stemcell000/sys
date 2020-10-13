class VialsController < ApplicationController
  
  
def index
      #Formattage des dates
      start_time = params[:date_gteq].to_date rescue Date.current
      start_time = start_time.beginning_of_day # sets to 00:00:00
      end_time = params[:date_lteq].to_date rescue Date.current
      end_time = end_time.end_of_day # sets to 23:59:59
      
      @q = Vial.ransack(params[:q])
      @q.sorts = ['name asc', 'date desc'] if @q.sorts.empty?
      vbs = @q.result
      @vials = vbs.includes([:virus_production]).order(:name).page params[:page]
      
      vb_ids = vbs.map{|vb|vb.id}
      
      @boxes = Box.joins(:vials).where(vials: {id: vb_ids})
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
    @box = Box.find(params[:box_id])
    @box_type = @box.box_type
    @v_max = @box_type.vertical_max
    @h_max = @box_type.horizontal_max
    
    @position_ids = @box.position_ids
    @position_names = @box.positions.sort_by{|position| position.nb}.map{|p|p.name.upcase()}
    
    @position_batch_ids = @box.positions.ids
   end
    @users = User.all
     set_unsorted_collection 
  end
  
  def update_box
  @vial = Vial.find(params[:vial_id])    
    if params[:position_id]
      position = Position.find(params[:position_id])
      if position.vial
        position.build_vial
      end
    else
      @vial.update_columns(:position_id => nil)
    end
    #
    @vial.position = position
    @vial.save!
    #
    @box = Box.find(params[:box_id])
    @box_type = @box.box_type
    #
    @v_max = @box_type.vertical_max
    @h_max = @box_type.horizontal_max
    #
    @position_ids = @box.position_ids
    @position_names = @box.positions.map{|p|p.name.upcase()}
    @position_batch_names = @box.positions.map{|p| p.vial.nil? ? "":p.vial.name}
    #
    set_unsorted_collection
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
      @arr = @vials.each_slice(4).to_a
    end
    
    def set_unsorted_collection
      @vials = Vial.where(trash: false).where(position_id: nil).order(:id)
      @arr = @vials.each_slice(5).to_a
    end
end

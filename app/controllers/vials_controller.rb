class VialsController < ApplicationController
  
before_action :set_vial, only:[:destroy, :edit, :show, :update]
before_action :set_collections, only: [:new, :edit]

def index
      #Formattage des dates
      start_time = params[:date_gteq].to_date rescue Date.current
      start_time = start_time.beginning_of_day # sets to 00:00:00
      end_time = params[:date_lteq].to_date rescue Date.current
      end_time = end_time.end_of_day # sets to 23:59:59
      #
      @batch_types_all = BatchType.all.order(name: "asc").uniq
      @batch_types_all = @batch_types_all.map{ |obj| [obj['name'], obj['id']] }
      @batches_all = Batch.all.order(name: "asc").uniq
      @batches_all = @batches_all.map{ |obj| [obj['name'], obj['id']] }
      #
      @q = Vial.ransack(params[:q])
      records = @q.result.includes(:position, :box, :batch)

      position_ids = records.pluck(:position_id)

      if params[:q].blank?
        record_boxes = Box.all
      else
        record_boxes = Box.joins(:positions).where(positions: {id: position_ids}).distinct
      end

      @option = current_user.options.first

      if @option.display_all == false
        records = records.where(out: false)
      end

      #Config de l'affichage des résultats.
      @pagy, @boxes = pagy(record_boxes.order(:name), items: 15, page_param: :page_box)
      @pagy_vials, @vials = pagy(records, items: 15, page_param: :page_vial)
end

def out_vials
#Formattage des dates
      start_time = params[:date_gteq].to_date rescue Date.current
      start_time = start_time.beginning_of_day # sets to 00:00:00
      end_time = params[:date_lteq].to_date rescue Date.current
      end_time = end_time.end_of_day # sets to 23:59:59
      #
      @batch_types_all = BatchType.all.order(name: "asc").uniq
      @batch_types_all = @batch_types_all.map{ |obj| [obj['name'], obj['id']] }
      @batches_all = Batch.all.order(name: "asc").uniq
      @batches_all = @batches_all.map{ |obj| [obj['name'], obj['id']] }
      @container_all = Container.all
      #
      @q = Vial.ransack(params[:q])
      records = @q.result.where(:out => true).order(:id)
      @pagy, @vials = pagy(records, vials: 30)
end
 
def new
    @vial = Vial.new
    @selected_positions = Position.joins(:box).order('boxes.name ASC').is_empty.order('nb')
end


def create
   @vial = Vial.create(vial_params)
   if  @vial.valid?
     flash.keep[:success] = "Vial created !"
     #Actualisation du nombre de vials pour le batch correspondant
     unless @vial.batch.nil?
      n = @vial.batch.vials.count
      @vial.batch.update_columns(vial_nb: n)
     end
     redirect_to sorter_vials_path
   else
     render action: "new"
   end
end

def edit
  current_position_id = @vial.position_id
  available_positions = Position.is_empty
  arr = available_positions.pluck(:id).push(current_position_id)
  @selected_positions = Position.joins(:box).order('boxes.name ASC').order('nb ASC').find(arr)
  end
end

def update
    @vial.update_attributes(vial_params)
     if @vial.valid?
       flash.keep[:success] = "Task completed!"
       if @vial.out == true
        @vial.update_columns(position_id: nil)
      end
       redirect_to params[:source]
    else
        render :action => 'edit'
    end
end

def show

end

def destroy
    @batch = @vial.batch
    redirect_to vials_path
    @vial.destroy
    flash.keep[:success] = "Vial destroyed !"
end
  
 def sorter
   set_unsorted_collection
 end
 
 def map_tube
   unless params[:box_id].nil?
      set_box_map
      unless params[:source].nil?
        @source = params[:source]
      end
   end
    @users = User.all
  end
   
  def update_box
      @vial = Vial.find(params[:vial_id])    
    if params[:position_id]
      position = Position.find(params[:position_id])
      @vial.position = position
      @vial.save!(validate: false)
      set_box_map
    #
    respond_to do |format|
      format.js
    end
    else
      @vial.update_columns(position_id: nil)
    end

    @vial.position = position
    @vial.save!(validate: false)
    set_box_map
    end
        #
    respond_to do |format|
      format.js
  end
  
  private
    def vial_params
      params.require(:vial).permit(:id, :name, :barcode, :volume, :box_id,
                                   :position_id, :out, :comment, :exit_date,
                                   :barcode, :recap, :batch_id, :user_id, :freezing_date,
                                   :source,
      :batch_attributes =>[:id, :name, :date, :passagenb, :patientnb, :clonenb, :culture, :corrected, :technique, :batch_type_id])                         
    end
    
    def set_vial
        @vial = Vial.find(params[:id])
    end

    def set_collections
      @batches = Batch.all.order(:name).uniq 
      @users = User.all.where.not(name: "superadmin")
    end
    
    def set_unsorted_collection
     @vials = Vial.where(position_id: nil, out: false).order(:id)
      @arr = @vials.each_slice(2).to_a
    end

    def set_box_map
      @vials = Vial.where(position_id: nil, out: false).order(:id)
    unless params[:box_id].nil?
      @box = Box.find(params[:box_id])
      @box_type = @box.box_type
      @v_max = @box_type.vertical_max
      @h_max = @box_type.horizontal_max
      #
      @storage_status= ""
      unless @box.rack_position_id.nil? 
          @storage_status = "stored in container " + @box.rack_position.shelf_rack.shelf.container.name+" / Rack : "+@box.rack_position.shelf_rack.name
      else
          @storage_status= "(unstored)"
      end
      #
      @position_ids = @box.positions.order(:nb).pluck(:id)
      @position_names = @box.positions.order(:nb).map{|p|(p.nb+1).to_s}
      @position_batch_names = @box.positions.order(:nb).map{|p| p.vial.nil? ? "" : p.vial.name}
      @position_batch_names_slots = @box.positions.order(:nb).map{|p| p.vial.nil? ? "" : p.vial.name.truncate(6)}
      @position_batch_ids = @box.positions.order(:nb).map{|p| p.vial.nil? ? "" : p.vial.id}
      @position_batch_volumes  = @box.positions.order(:nb).map{|p| p.vial.nil? ? "-" : "#{p.vial.volume}"}
      @position_batch_bcs  = @box.positions.order(:nb).map{|p| p.vial.nil? ? "-" : "#{p.vial.barcode}"}
      @position_batch_freez  = @box.positions.order(:nb).map{|p| p.vial.nil? ? "-" : "#{p.vial.freezing_date}"}
      @position_batch_cmts = @box.positions.order(:nb).map{|p| p.vial.nil? ? "-" : "#{p.vial.comment}"}
      @position_batch_recaps = @box.positions.order(:nb).map{|p| p.vial.nil? ? "-" :"#{p.vial.recap}"}
      #
      @arr = @vials.each_slice(2).to_a
      @users = User.all.where.not(role: "superadmin")
    end
  end
end

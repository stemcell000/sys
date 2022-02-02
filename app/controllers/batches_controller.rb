class BatchesController < ApplicationController

	before_action :set_batch, only:[:destroy, :edit, :add_vials, :show, :update, :update_vials]
	before_action :set_collections, only:[:new, :edit, :index]
	def resource_name
    :batch
  	end

	def index
		@q = Batch.ransack(params[:q])
		records = @q.result(distinct: true).order(:name)
		#Config de l'affichage des résultats.
    	@pagy, @batches = pagy(records, batches: 30)
	end

	def new
		@batch = Batch.new
	end

	def create
   		@batch = Batch.create(batch_params)
   		
   		if  @batch.valid?
   			i=0
		#Création des batches
		1.upto(@batch.vial_nb) do
			i+=1
			vial = @batch.vials.new
			vial.name = @batch.name+"."+i.to_s
			vial.save!(validate: false)
		end
  
	     	flash.keep[:success] = "Batch created !"
	     	redirect_to add_vials_batch_path(@batch)
   		else
     		render action: "new"
   		end
	end

	def edit

	end

	def add_vials

	end

	def update
		@batch.update_attributes(batch_params)
		if  @batch.valid?
			flash.keep[:success] = "Batch updated !"
			redirect_to add_vials_batch_path(@batch)
		else
			render action: "edit"
		end
	end

	def update_vials
		@batch.update_attributes(batch_params)
		if  @batch.valid?
			@batch.update_columns(vial_nb: @batch.vials.count)
			flash.keep[:success] = "Batch updated !"
			redirect_to @batch
		else
			render action: "add_vials"
		end
	end

	def destroy
		@batch.destroy
		redirect_to batches_path
		flash.keep[:success] = "Batch destroyed !"
	end

	def show
		records = @batch.vials
		#@pagy, @vials = pagy(records.order(:id), vials: 10)
		@pagy_vials, @vials = pagy(records.order(name: :asc), items: 15, page_param: :page_vial)
	end

	private

	def set_batch
		@batch = Batch.find(params[:id])
	end

	def set_collections
		@users = User.all.where.not(role: "superadmin")
		@users_collection = User.all.order(lastname: "asc").where.not(role: 'superadmin').uniq.map{ |obj| [obj.full_name, obj['id']] }
		@patients_collection = Batch.all.order(patientnb: "asc").pluck(:patientnb).uniq	
		@clones_collection = Batch.all.order(clonenb: "asc").pluck(:clonenb).uniq
	end

	def batch_params
      params.require(:batch).permit(
        :name, :batch_type_id, :description, :user_id, :vial_nb, :passagenb, :patientnb, :clonenb, :culture, :corrected, :technique, :source,
        vials_attributes: [:id, :name, :barcode, :volume, :box_id,
                                   :position_id, :out, :comment,
                                   :barcode, :recap, :batch_id])
    end
end

class BatchesController < ApplicationController

	before_action :set_batch, only:[:destroy, :edit, :add_vials, :show, :update, :update_vials]

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
		@pagy, @vials = pagy(records.order(:id), vials: 10)
	end

	private

	def set_batch
		@batch = Batch.find(params[:id])
	end

	def batch_params
      params.require(:batch).permit(
        :name, :batch_type_id, :description, :date, :user_id, :vial_nb,
        vials_attributes: [:id, :name, :barcode, :volume, :box_id,
                                   :position_id, :out, :comment, :exit_date,
                                   :barcode, :recap, :batch_id])
    end
end

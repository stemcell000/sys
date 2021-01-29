class ColorsController < ApplicationController
	private
    def color_params
      params.require(:color).permit(
        :name, :code)
    end
    
    def set_box
      @color = Color.find(params[:id])
    end
end

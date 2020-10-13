class BoxTypesController < InheritedResources::Base

  private

    def box_type_params
      params.require(:box_type).permit()
    end
end


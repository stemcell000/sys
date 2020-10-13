class ShelvesController < InheritedResources::Base

  private

    def shelf_params
      params.require(:shelf).permit()
    end
end


class OptionsController < InheritedResources::Base

before_action :set_option, only: [:edit, :update]
before_action :set_current_user_option, only: [:display_all_switch]

def display_all_switch
  @option.toggle!(:display_all)
 #redirect_to :controller => 'items', :action => 'index', :id => @option.id
    respond_to do |format|
     #format.html
      format.js
    end
end 

private
  def set_option
    @option = Option.find(params[:id])
  end
  
  def set_current_user_option
    @option = current_user.options.first
  end

  def option_params
    params.require(:option).permit(:id, :display_all)
  end

end

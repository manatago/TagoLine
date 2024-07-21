require 'rails/all'

module TagoLine
  class LoginAction
    def self.stateIsRight(controller)
        controller.session[:line_state] == controller.params[:state]
    end
    
  end
end
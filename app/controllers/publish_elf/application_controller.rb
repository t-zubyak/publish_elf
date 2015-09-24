module PublishElf
  class ApplicationController < ActionController::Base

    helper_method :render_404, :verify_publisher

    def verify_publisher
      redirect_to root_path unless current_user.publisher?
    end

    def render_404
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
        format.xml  { head :not_found }
        format.any  { head :not_found }
      end
    end
  end
end

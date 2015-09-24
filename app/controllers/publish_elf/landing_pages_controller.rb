module PublishElf
  class LandingsController < ApplicationController

    layout :resolve_layout

    before_filter :authenticate_user!, :except => [:index, :show]
    before_filter :verify_publisher, except: [:index, :show]

    def index
      if current_user
        @landings = current_user.publisher? ? LandingPage.scoped : LandingPage.published
      else
        render_404 and return
      end
    end

    def new
      @landing = LandingPage.new(:publish_date => Time.zone.today)
    end

    def create
      @landing = LandingPage.new(params[:landing])
      @landing.page_url = @landing.title.parameterize
      if params[:previous_background_id].present?
        @landing.background = LandingPage.find(params[:previous_background_id].gsub("_bg", "")).background
      end
      if @landing.save
        redirect_to landings_path, notice: 'Landing page was successfully created.'
      else
        render action: "new"
      end
    end

    def edit
      @landing = LandingPage.find(params[:id])
    end

    def update
      @landing = LandingPage.find(params[:id])
      if @landing.update_attributes(params[:landing])
        if params[:previous_background_id].present?
          @landing.background = LandingPage.find(params[:previous_background_id].gsub("_bg", "")).background
          @landing.save
        end
        redirect_to landings_path, notice: 'Landing page was successfully updated.'
      else
        render action: "edit"
      end
    end

    def show
      @landing = LandingPage.find(params[:id])
      render_404 and return if @landing.nil?
    end

    def destroy
      @landing = LandingPage.find(params[:id])
      @landing.destroy
      redirect_to landings_url
    end

    private

    def resolve_layout
      case action_name
      when "show"
        "landing"
      else
        "public"
      end
    end

  end
end

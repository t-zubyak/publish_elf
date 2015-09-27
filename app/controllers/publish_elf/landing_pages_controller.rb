module PublishElf
  class LandingPagesController < ApplicationController

    layout :resolve_layout

    before_filter :authenticate_user!, :except => [:index, :show]
    before_filter :verify_publisher, except: [:index, :show]

    def index
      if current_user
        @landings = current_user.publisher? ? LandingPage.all : LandingPage.published
      else
        redirect_to root_path
      end
    end

    def new
      @landing = LandingPage.new(:publish_date => Time.zone.today)
    end

    def create
      @landing = LandingPage.new(page_params)
      @landing.page_url = @landing.title.parameterize
      if @landing.save
        redirect_to landing_pages_path, notice: 'Landing page was successfully created.'
      else
        render action: "new"
      end
    end

    def edit
      @landing = LandingPage.find(params[:id])
    end

    def update
      @landing = LandingPage.find(params[:id])
      if @landing.update_attributes(page_params)
        redirect_to landing_pages_path, notice: 'Landing page was successfully updated.'
      else
        render action: "edit"
      end
    end

    def show
      @landing = LandingPage.find(params[:id])
      redirect_to root_path and return if @landing.nil?
    end

    def destroy
      @landing = LandingPage.find(params[:id])
      @landing.destroy
      redirect_to landing_pages_url
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

    def page_params
      params.require(:landing_page).permit(:title, :status, :publish_date, :content, :page_url)
    end

  end
end

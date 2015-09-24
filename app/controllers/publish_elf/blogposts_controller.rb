module PublishElf
  class BlogpostsController < PublishElf::ApplicationController

    before_filter :authenticate_user!, except: [:index, :show]
    before_filter :verify_publisher, except: [:index, :show]

    layout 'public'

    def index
      if current_user && current_user.publisher?
        @posts = Blogpost.all
      else
        @posts = Blogpost.published
      end

      if params[:author].present?
        u = User.where(first_name: params[:author].split("-")[0].humanize, last_name:params[:author].split("-")[1].humanize).first
        @posts = @posts.where(user_id: u.id)
        @custom_title = "Written by: #{params[:author].split("-")[0].humanize} #{params[:author].split("-")[1].humanize}"
      end

      if params[:tag_name].present?
        @posts = @posts.tagged_with params[:tag_name].split("-").join(" ")
        @custom_title = "Tagged With: #{params[:tag_name].split("-").join(" ").humanize}"
      end

      @posts = @posts.order("posted_on desc").paginate(page: params[:page], per_page: 10)

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @posts }
      end
    end

    # GET /posts/1
    # GET /posts/1.json
    def show
      @post = Blogpost.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @post }
      end
    end

    # GET /posts/new
    # GET /posts/new.json
    def new
      @post = Blogpost.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @post }
      end
    end

    # GET /posts/1/edit
    def edit
      @post = Blogpost.find(params[:id])
    end

    # POST /posts
    # POST /posts.json
    def create
      @post = Blogpost.new(blogpost_params)

      respond_to do |format|
        if @post.save
          format.html { redirect_to @post, notice: 'Post was successfully created.' }
          format.json { render json: @post, status: :created, location: @post }
        else
          format.html { render action: "new" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /posts/1
    # PUT /posts/1.json
    def update
      @post = Blogpost.find(params[:id])

      respond_to do |format|
        if @post.update_attributes(blogpost_params)
          format.html { redirect_to @post, notice: 'Post was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /posts/1
    # DELETE /posts/1.json
    def destroy
      @post = Blogpost.find(params[:id])
      @post.destroy

      respond_to do |format|
        format.html { redirect_to posts_url }
        format.json { head :no_content }
      end
    end

    def sign_s3
      bucket_name = AWS_CONFIG[:s3_bucket_name]
      original_name = params['file_name']
      original_extension = original_name.split('.').last
      mime_type = params['file_type']
      object_name = Time.now.to_f.to_s.gsub('.','') + '.' + original_extension
      date = Time.now.utc.iso8601.gsub(/-|:/,'')
      amazon_headers = ["x-amz-acl:public-read","x-amz-date:#{date}"] # set the public read permission on the uploaded file
      string_to_sign = "PUT\n\n#{mime_type}\n\n#{amazon_headers[0]}\n#{amazon_headers[1]}\n/#{bucket_name}/post_images/#{object_name}";
      signature = Base64.strict_encode64(OpenSSL::HMAC.digest('sha1',  AWS_CONFIG[:aws_secret_access_key], string_to_sign))
      path = "https://s3.amazonaws.com/#{bucket_name}/post_images/#{object_name}"
      r = {
        signature:  "AWS #{AWS_CONFIG[:aws_access_key_id]}:#{signature}",
        date: date,
        url: path,
      }
      render json: r
    end

    private

    def blogpost_params
      params.require(:blogpost).permit(:body, :posted_on, :title, :status, :tag_list, :user_id)
    end
  end
end

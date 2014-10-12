class CommentsController < ApplicationController
  before_filter :authorize, :except => [:index, :new, :create]
  before_action :set_comment, :only => [:show, :edit, :update, :destroy, :validate_comment]

  # GET /comments
  # GET /comments.json
  def index
    params.permit(:post_id)
    if params[:post_id]
      if current_user.is_admin?
        @comments = Comment.where(:post_id => params[:post_id]).includes(:user)
      else
        @comments = Comment.where(:post_id => params[:post_id], :is_validated => true).includes(:user)
      end
    end
  end

  def validate_comment
    @comment.is_validated = true
    @comment.save
    flash[:notice] = "Commentaire validé."
    redirect_to request.referer
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    if current_user
      @comment = Comment.new
      @comment.post_id = params[:post_id]
    else
      redirect_to :controller => :posts, :action => :index, notice: 'Vous devez être connecté pour poster un commentaire.'
    end
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.is_validated = false
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: "Votre commentaire a été posté. Il sera visible lorsque qu'il aura été validé." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content, :post_id)
    end
end

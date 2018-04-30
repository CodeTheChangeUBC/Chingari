class DocumentsController < ApplicationController

  def index
      if !logged_in?
      redirect_to '/login'
    end
    @documents = Document.all # list of existing documents
    @new_document = Document.new # blank document to render form with
  end

  def new
    @new_document = Document.new # blank document to render form with
    render :layout => false
  end

  def create
    if !logged_in?
      redirect_to '/login'
    end
    @new_document = Document.new(params[:document].permit(:title, :file)) # Totally not safe, please don't do this on prod
    @new_document.creator = User.first
    @new_document.attachable = Course.first
    #@new_document.display_index = Document.where(attachable_id: Course.first.id).map{|d| d.display_index}.max + 1
    @errors = nil
  	if @new_document.save
  		flash[:success] = "Document Created"
      # redirect_to @user
      redirect_to "/documents/"
    else
      print @new_document.errors.to_s
      @documents = Document.all # list of existing documents
      @errors = @new_document.errors.messages
      # @new_document = Document.new # blank document to render form with
  		render 'index'
  	end
  end

  def delete
      if !logged_in?
      redirect_to '/login'
    end
    Document.find(params[:document_id]).destroy
    flash[:success] = "Document Deleted"
    redirect_to "/documents/"
  end

end

class Spree::Admin::PagesController < Spree::Admin::ResourceController


  def create
    invoke_callbacks(:create, :before)
    @object.attributes = permitted_resource_params
    if @object.save
      invoke_callbacks(:create, :after)
      flash[:success] = flash_message_for(@object, :successfully_created)
      respond_with(@object) do |format|
        format.html { redirect_to location_after_save }
        format.js   { render :layout => false }
      end
    else
      invoke_callbacks(:create, :fails)
      respond_with(@object)
    end
  end

  def news_index
    @news = News.all

  end

  def edit_news
    @news = ::News.find(params[:news_item_id])
  end

  def add_news
    @news = News.new
  end


  private

  def permitted_resource_params
    params.require(object_name).permit(:title, :slug, :body, :position, :show_in_header, :show_in_footer, :visible, :meta_title, :meta_keywords, :meta_description, photos_attributes: [:id, :content, :alt, :_destroy])
  end

  
end

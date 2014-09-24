module Spree
  class TaxonsController < Spree::StoreController
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    helper 'spree/products'

    respond_to :html

    def show
      @taxon = Taxon.find_by_permalink!(params[:id])
      return unless @taxon

      @searcher = build_searcher(params.merge(:taxon => @taxon.id))
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end
    def show_all
      @taxon = Taxon.find_by_permalink!(params[:id])

      base_scope = Spree::Product.active
      base_scope = base_scope.in_taxon(@taxon)
      @products_scope = base_scope

      @products = @products_scope.includes([:master => :prices])



      return unless @taxon

      # @searcher = build_searcher(params.merge(:taxon => @taxon.id))
      # @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
      render 'show'
    end

    def series
      p = Spree::Product.find(params[:id])
      @products = p.series
      @taxonomies = Spree::Taxonomy.includes(root: :children)
      render 'show'
    end

    private

    def accurate_title
      if @taxon
        @taxon.seo_title
      else
        super
      end
    end

  end
end

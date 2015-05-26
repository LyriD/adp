module Spree

  class StaticContentController < Spree::StoreController
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404

    skip_before_filter :verify_authenticity_token, only: [:sync_upload]

    # skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }



    helper 'spree/products'
    # layout :determine_layout
    respond_to :html

    # before_filter :check_ip, only: [:sync_download, :sync_upload]

    def sync_download

      products = Spree::Product.all
      out = {}
      products.each do |product|
        i=0
        product.variants.each do |v|
          v.stock_items.each do |si|
            i+=si.count_on_hand
          end
        end
        out[product.name] = i
      end
      Rails.logger.info "---request.remote_ip---> #{request.remote_ip}"

      render json: out.to_json

    end

    def sync_upload
      Rails.logger.info "---request.request.raw_post---> #{request.raw_post}"
      # Rails.logger.info "---request.remote_ip---> #{request.remote_ip}"
      #
      # Rails.logger.info "========request.format========  #{request.format}"
      # Rails.logger.info "========Hash.from_xml(request.raw_post)[rests]========  #{Hash.from_xml(request.raw_post)["Rests"]}"
      #  Rails.logger.info "================ PARAMS #{params}"
      #
      # s_m = Spree::StockMovement.all
      # unless    Spree::StockMovement.all.any?
      Hash.from_xml(request.raw_post)["Rests"].each do |result|
        # result[elem["id"]] = elem["quantity"]
        result.to_a[1].each do |a|
          product = a.to_h

          Rails.logger.info "product ===========================================================================================================================> #{product.to_json}"

          key = product['id']
          value = product['quantity'].to_i



          # check_s_m = Spree::StockMovement.where(["created_at > ?", Sync.all.last.created_at]) #нашли все перемещения после последней синхронизации


          # Rails.logger.info "key ====================> #{key}"
          # Rails.logger.info "value ====================> #{value}"
          if Product.where(name: key).any?
              variant = Product.find_by_name(key).master

            Rails.logger.info "-------> product syncronized #{key}"

          else
            Rails.logger.info "-------> create p #{key}"

            created_product = Product.create(name: key, sku: key, prototype_id: 4, price: 0, available_on: '11.11.2090', shipping_category_id: 1)
            Rails.logger.info "-------> create p id #{created_product.id}"

            variant = created_product.master
          end

          # difference найти сколько добавилось (вычесть из прилетевшего то что было)
          c_o_h_before = 0
          variant.stock_items.each do |si|
            si.stock_movements.where(["created_at < ?", Sync.all.last.created_at]).each do |sm|
              c_o_h_before+=sm.quantity
              Rails.logger.info "sm!!!!! ----------> #{sm.quantity}"
            end
            # Rails.logger.info "I  !!!!! ----------> #{i}" if product.name == 'AHB-1543-A13 VG'
          end
          difference = value - c_o_h_before

          Rails.logger.info "value ----> #{value}"
          Rails.logger.info "c_o_h_before ----> #{c_o_h_before}"
          Rails.logger.info "difference ----> #{difference}"
          # СКОЛЬКО ПРИЛЕТЕЛО НОВЫХ!!! найти сколько убавилось в магазине




          # СКОЛЬКО УБАВИЛОСЬ ЗА ВРЕМЯ!!
          #      check_s_m.each do |s_m|
          #     variant.stock_items.each do |si|
          #       if s_m.stock_item_id == si.id   #нашли количество изменений в товаре после посл синхронизации
          #         difference = difference+s_m.quantity     # внесли изменения
          #       end
          #     end
          #   end





          # Rails.logger.info "var - #{variant.id}"
          stock_location = StockLocation.find(2)
          Rails.logger.info "StockLocation - #{stock_location}"
          stock_movement = stock_location.stock_movements.build(quantity: difference)
          stock_movement.stock_item = stock_location.set_up_stock_item(variant)
          Rails.logger.info "stock_movement.stock_item - #{stock_movement.stock_item}"
          Rails.logger.info "stock_movement.quantity - #{stock_movement.quantity}"
          stock_movement.stock_item.adjust_count_on_hand(stock_movement.quantity)
          stock_movement.save




          Rails.logger.info "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"

        end

      end if Hash.from_xml(request.raw_post)
      # end



      #
      Sync.create! if Hash.from_xml(request.raw_post)

      products = Spree::Product.all
        out = {}
      #
      # #
      # #
      # #
      #



      products.each do |product|
        i=0
          # Rails.logger.info "Product!!!!! -----------------------------------> #{product.id} #{product.name}" if product.name == 'AHB-1543-A13 VG'
        product.master.stock_items.each do |si|
            si.stock_movements.each do |sm|
              i+=sm.quantity
              # Rails.logger.info "sm!!!!! ----------> #{sm.quantity}" if product.name == 'AHB-1543-A13 VG'
            end
            # Rails.logger.info "I  !!!!! ----------> #{i}" if product.name == 'AHB-1543-A13 VG'
        end
        out[product.name] = i
      end
      render json: out.to_json
    end

    def show
      @page = Spree::Page.visible.find_by_slug!(request.path)
    end

    def show_news_item
      @news = News.find(params[:news_item_id])
    end

    def series
      p = Spree::Product.find(params[:id])
      @products = p.series
      # render 'spree/products/index'
    end

    private

      def stock_movement_params

      end

      def determine_layout
        return @page.layout if @page and @page.layout.present? and not @page.render_layout_as_partial?
        Spree::Config.layout
      end

      def accurate_title
        @page ? (@page.meta_title.present? ? @page.meta_title : @page.title) : nil
      end

      def check_ip
        Rails.logger.info "...request.remote_ip....#{request.remote_ip}"
        Rails.logger.info "...Spree::Config[:remote_ip]....#{Spree::Config[:remote_ip]}"
        if request.remote_ip == Spree::Config[:remote_ip]
          return true
        else
          redirect_to root_path
        end
      end

  end
end

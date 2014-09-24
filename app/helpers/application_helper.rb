module ApplicationHelper


    def product_count(p)

      i=0
        @product.master.stock_items.each do |si|
          i+=display_count(si)
        end

      res = case i
        when -99999..0 then "<i style='color:#fc1116;'>Отсутствует!</i>"
        when 1..6 then "<i style='color:#D82125;'>Последний экземпляр!</i>"
        when 7..12 then "<i style='color: #D38209;'>Наличие ограничено</i>"
        when 13..999999 then "<i style='color: #308F1A;'>Есть в наличии!</i>"
      end

      raw res

    end

    def display_count(stock_item)
      i=0
      stock_item.stock_movements.each do |sm|
        i+=sm.quantity
      end
      Rails.logger.info "#{stock_item.id}  ----ololo - ravno ----> #{i}"
      i

    end


    def check_quantity(order)

      spsr = true
      order.line_items.each do |line_item|
        line_item.product.master.stock_items.each do |stock_item|
           if display_count(stock_item) < 0
             spsr = false
             break
           end
        end
      end

      spsr

    end


end

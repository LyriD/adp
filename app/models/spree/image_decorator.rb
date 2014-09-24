Spree::Image.class_eval do
attachment_definitions[:attachment][:styles] = {
     :mini => '48x48>', # thumbs under image
     :small => '230x155>', # images on category view
     :product => '350x233>', # full product image
     :large => '600x600>' # light box image
}
end
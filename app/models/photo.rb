class Photo < ActiveRecord::Base

  belongs_to :page, :class_name => 'Spree::Page'

  #has_attached_file :content, :styles => { :home => "893x240#", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  #validates_attachment_content_type :content, :content_type => /\Aimage\/.*\Z/

  attr_accessor :content_file_name

  mount_uploader :content, ItemUploader

end

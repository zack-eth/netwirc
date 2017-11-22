class UserPicture < ActiveRecord::Base
  belongs_to :user

  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :max_size => 500.kilobytes,
                 :resize_to => '320x200>',
                 :thumbnails => { :thumb => '100x100>' }

  validates_as_attachment

  validates_format_of :content_type, :with => /^image/, :message => "--- you can only upload pictures"
  def picture=(picture_field)
#    self.name = base_part_of(picture_field.original_filename)
    self.content_type = picture_field.content_type.chomp
    self.data = picture_field.read
  end
  def base_part_of(file_name)
#    name = File.basename(file_name)
#    name.gsub(/[^\w._-]/, '')
  end
end

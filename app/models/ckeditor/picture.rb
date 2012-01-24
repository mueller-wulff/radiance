class Ckeditor::Picture < Ckeditor::Asset
  has_attached_file :data,
    :url  => "/system/ckeditor_assets/pictures/:id/:style_:basename.:extension",
    :path => ":rails_root/public/system/ckeditor_assets/pictures/:id/:style_:basename.:extension",
    :styles => { :content => '575>', :thumb => '80x80#' }

  validates_attachment_size :data, :less_than => 2.megabytes
  validates_attachment_presence :data

  def url_content
    url(:content)
  end
end

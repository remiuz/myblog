class Post < ActiveRecord::Base
  include PgSearch
  acts_as_taggable_on :tags
  belongs_to :user
  has_many :comments

  pg_search_scope :quick_search, against: [:title, :content], associated_against: {tags: [:name]}

  has_attached_file :image, :storage => :s3,:bucket => 'demo-my-blog',:url => ":s3_domain_url",
    :path => "/:class/avatars/:id_:basename.:style.:extension"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end

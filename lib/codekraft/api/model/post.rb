module Codekraft
  module Api
    module Model
      class Post < Base
        belongs_to :user
        #default_scope -> { where('published_at <= ?', Time.zone.now).order(published_at: :desc) }
        default_scope -> { order(published_at: :desc, created_at: :desc) }
        #scope :published, -> { where('published_at <= ?', Time.zone.now).order(published_at: :desc) }
        has_many :attachments, as: :parent, dependent: :destroy
        has_and_belongs_to_many :hashtags
        has_and_belongs_to_many :metauris

        def self.content_attr(attr_name, attr_type = :string)
          content_attributes[attr_name] = attr_type

          define_method(attr_name) do
            self.payload ||= {}
            self.payload[attr_name.to_s]
          end

          define_method("#{attr_name}=".to_sym) do |value|
            self.payload ||= {}
            self.payload[attr_name.to_s] = value
          end
        end

        def self.content_attributes
          @content_attributes ||= {}
        end
      end
    end
  end
end

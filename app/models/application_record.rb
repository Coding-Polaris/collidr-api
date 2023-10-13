class ApplicationRecord < ActiveRecord::Base
  include Wisper::Publisher
  include SaveBroadcaster

  primary_abstract_class
end

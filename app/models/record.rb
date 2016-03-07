class Record < ActiveRecord::Base
  belongs_to :dataset
  serialize :data, Hash
end

class User < ActiveRecord::Base
    has_one :player, class_name: '::Player'
end
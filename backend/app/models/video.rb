class Video < ApplicationRecord
    #favoriteテーブルと繋ぐ
    has_many :favorites, dependent: :destroy
end

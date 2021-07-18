class Favorite < ApplicationRecord
  #中間テーブルとしてusersテーブルとvideosテーブルを繋ぐ
  belongs_to :user
  belongs_to :video
  #memoテーブルと繋ぐ
  has_many :memos, dependent: :destroy

  # 同じ動画を複数回お気に入り登録させないためにバリデーションを追加
  validates_uniqueness_of :video_id, scope: :user_id
end

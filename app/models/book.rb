class Book < ApplicationRecord
  validates :title, presence: true
  validates :body, length: { in: 1..200 }
  belongs_to :user

  is_impressionable #PV数

  # カウント
  has_many :view_counts, dependent: :destroy
  # フォロー機能
  has_many :following_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人

  # コメント機能
  has_many :book_comments, dependent: :destroy
  
  # いいね機能
  has_many :favorites, dependent: :destroy

  # 検索機能
    def self.looks(searches, words)
      if searches == "perfect_match"
        @book = Book.where("title LIKE?","#{words}")
      elsif searches == "forward_match"
        @book = Book.where("title LIKE?","#{words}%")
      elsif searches == "backward_match"
        @book = Book.where("title LIKE?","%#{words}")
      elsif searches == "partial_match"
        @book = Book.where("title LIKE?","%#{words}%")
      else
        @book = Book.all
      end
  end
end

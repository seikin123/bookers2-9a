class User < ApplicationRecord
  validates :name, presence: true, uniqueness:true, length: {in: 2..20}
  validates :introduction,length: { maximum: 50}


  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  attachment :profile_image
  has_many :books, dependent: :destroy
  #カウント  
  has_many :view_counts, dependent: :destroy

  # コメント機能
  has_many :book_comments, dependent: :destroy

  # チャット機能
  has_many :user_rooms
  has_many :chats
  has_many :rooms, through: :user_rooms

  # フォロー機能
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # フォロー取得
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy # フォロワー取得
  has_many :following_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人
    # ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end

  def matchers
    follower & followed
  end

  # いいね機能
  has_many :favorites, dependent: :destroy

  def already_favorited?(book)
    self.favorites.exists?(book_id: book.id)
  end

  # 検索機能
  def self.looks(searches, word)
    if searches == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif searches == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif searches == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif searches == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end
end

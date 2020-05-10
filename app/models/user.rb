class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,:validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  attachment :profile_image, destroy: false

  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user

   def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  def self.search(method, search)
    if method == "forward_match"
        User.where(['name LIKE?', "#{search}%"])
      elsif method == "backward_match"
        User.where(['name LINKE?', "%#{search}"])
      elsif method == "perfect_match"
        User.where(['name LIKE?', "#{search}"])
      else method =="partial_match"
        User.where(['name LIKE?', "%#{search}%"])
      end
  end

#include JpPrefectureでJpPrefecture::Prefectureを呼び出せるようにしてる
  include JpPrefecture
  jp_prefecture :prefecture_code
#13とかの数字をprefecture_code(都道府県のコード)として認識するために宣言してる
  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
    #JpPrefectureのPrefectureの中から検索されたコードを探し、name(都道府県名)に変換してる
  end

  def prefecture_name(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).name
  end


  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, presence:true, length:{maximum:20,minimum:2}
  validates :introduction, length:{maximum:50}
end


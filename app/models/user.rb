class User < ApplicationRecord
  has_many :works, dependent: :destroy
  default_scope -> { order(id: :asc) }
  validates :name, presence: true, length: { maximum: 20 }
  VALID_NUMBER_REGEX = /\A[0-9][0-9][0-9][0-9]\z/
  validates :number, presence: true, length: { is: 4 },
              format: {with: VALID_NUMBER_REGEX},
              uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  validates :money, numericality: {greater_than: 954}

    # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
end

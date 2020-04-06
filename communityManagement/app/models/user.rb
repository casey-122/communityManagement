class User < ApplicationRecord
  validates_format_of :user_id, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # before_save {self.email.downcase!}  #{self.email = email.downcase}
  # VALID_EMAIL_RRGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  # validates :email, presence: true, length: {maximum: 50},
  #           format: {with: VALID_EMAIL_RRGEX},
  #           uniqueness: {case_sensitive:false}   #对大小写不敏感

  #当前用户为管理员？
  def admin?
    self.role == "admin"
  end

  #当前用户为社团成员？
  def member?
    self.role == "member"
  end

  #当前用户为社长？
  def president?
    self.role == "president"
  end

  #当前用户为社联主席？
  def chairman?
    self.role == "chairman"
  end

  attr_writer :login

  def login
    @login || self.user_id || self.email
  end

  validate :validate_user_id

  def validate_user_id
    if User.where(email: user_id).exists?
      errors.add(:user_id, :invalid)
    end
  end

  # def self.find_for_database_authentication(warden_conditions)
  #   conditions = warden_conditions.dup
  #   if login = conditions.delete(:login)
  #     where(conditions.to_h).where(["lower(user_id = :value OR lower(email) = :value", { :value => login.downcase }]).first
  #   elsif conditions.has_key?(:user_id) || conditions.has_key?(:email)
  #     where(conditions.to_h).first
  #   end
  # end
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(user_id) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:user_id].nil?
        where(conditions).first
      else
        where(user_id: conditions[:user_id]).first
      end
    end
  end

end

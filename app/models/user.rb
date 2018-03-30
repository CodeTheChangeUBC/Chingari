class User < ApplicationRecord
	before_save { email.downcase! }
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 6, maximum: 255}, 
    				allow_nil: true
	has_secure_password

  	has_many :enrollments, dependent: :destroy
  	has_many :courses, through: :enrollments

	# Returns the hash digest of the given string.
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
	                                              BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# Given an auth hash from third party API,
	# either log the given user in if they exist, or create new user
	# with given info
	def self.find_or_create_from_auth_hash(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
			# Create new user if couldn't find them
			password = SecureRandom.urlsafe_base64
			user.provider = auth.provider
			user.uid = auth.uid
			user.name = auth.info.first_name + auth.info.last_name
			user.email = auth.info.email
			user.password = password
			user.password_confirmation = password
			user.save!
		end
	end
end

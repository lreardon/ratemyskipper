class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable
	devise :omniauthable, omniauth_providers: %i[facebook google_oauth2]

	attribute :firstname, :firstname
	attribute :lastname, :lastname
	attribute :email, :string
	attribute :phantom, :boolean, default: false
	attribute :admin, :boolean, default: false

	validates :firstname, :lastname, presence: true
	validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: Devise.email_regexp }

	has_many :created_skippers, class_name: 'Skipper', foreign_key: :creator_id, dependent: :nullify
	has_many :authored_reviews, class_name: 'Review', foreign_key: :author_id, dependent: :destroy
	has_many :added_friendships, class_name: 'Friendship', foreign_key: :friend_id, dependent: :destroy

	scope :confirmed, -> { where.not(confirmed_at: nil) }

	def self.from_omniauth(auth)
		name_split = auth.info.name.split(' ')
		user = User.where(email: auth.info.email).first
		user ||= User.create!(
			provider: auth.provider,
			uid: auth.uid,
			firstname: name_split[0],
			lastname: name_split[1],
			email: auth.info.email,
			password: Devise.friendly_token[0, 20],
			confirmed_at: DateTime.now
		)
		user
	end

	### Write Methods

	# Interactions with other users

	def request_friendship_with!(user)
		if friendship_with?(user)
			# If duplicate request is to a user who previously sent a request that was rejected, don't complain.
			unless Friendship.where(user_id: user.id, friend_id: id, status: Friendships::Statuses.REJECTED).exist?
				raise AlreadyExistsError
			end
		end

		Friendship.create!(user_id: id, friend_id: user.id)
	end

	# ----

	# Interactions with skippers

	def create_skipper!(skipper_params)
		Skipper.create!(creator_id: id, **skipper_params)
	end

	def delete_skipper!(skipper)
		raise UnauthorizedActionError unless can_delete_skipper?(skipper)

		skipper.delete
	end

	def save_skipper!(skipper)
		old_skipper_ids = saved_skipper_ids || []
		raise DuplicateRecordError if old_skipper_ids.include?(skipper.id)

		new_skipper_ids = old_skipper_ids.append(skipper.id)
		Rails.cache.write(saved_skippers_key, new_skipper_ids)
	end

	def unsave_skipper!(skipper)
		old_skipper_ids = saved_skipper_ids || []
		raise NoReferenceObjectError unless old_skipper_ids.include?(skipper.id)

		new_skipper_ids = old_skipper_ids.filter { |id| id != skipper.id }
		Rails.cache.write(saved_skippers_key, new_skipper_ids)
	end
	# ----

	# -------------------------------------------

	def can_edit_or_delete_skipper?(skipper)
		can_delete_skipper?(skipper) || can_edit_skipper?(skipper)
	end

	def can_delete_skipper?(skipper)
		skipper.creator_id == id || admin?
	end

	def can_edit_skipper?(skipper)
		skipper.creator_id == id || admin?
	end

	def reviewed_skipper?(skipper)
		authored_reviews.map(&:skipper_id).include?(skipper.id)
	end

	def wrote_review?(review)
		authored_reviews.map(&:id).include?(review.id)
	end

	def name
		"#{firstname} #{lastname}".titleize
	end

	def friendship_with?(user)
		users_in_friendship_sent_by_self = Friendship.where(user_id: id)
		users_in_friendship_sent_to_self = Friendship.where(friend_id: id)

		users_in_friendship = users_in_friendship_sent_by_self | users_in_friendship_sent_to_self

		users_in_friendship.include?(user.id)
	end

	def friends_with?(user)
		friends.include?(user)
	end

	def pending_friends_with?(user)
		friendships.pending.map(&:friend).include?(user)
	end

	def reject_friend_request!(friendship)
		friendship.update!(status: Friendships::Statuses::REJECTED)
	end

	def accept_friend_request!(friendship)
		friendship.update!(status: Friendships::Statuses::ACCEPTED)
	end

	def rejected_friends_with?(user)
		friendships.rejected.map(&:friend).include?(user)
	end

	# Friendships

	def friendships
		friendships_sent_by_user = Friendship.accepted.where(user_id: id)
		friendships_sent_to_user = Friendship.accepted.where(friend_id: id)

		friendships_sent_by_user | friendships_sent_to_user
	end

	def pending_friendships
		Friendship.pending.where(friend_id: id)
	end

	def accepted_friendships
		Friendship.accepted.where(friend_id: id).or(Friendship.accepted.where(user_id: id))
	end

	def rejected_friendships
		Friendship.rejected.where(friend_id: id)
	end

	# Friends

	def friends
		friends_sent_by_user = Friendship.accepted.where(user_id: id).map(&:friend)
		friends_sent_to_user = Friendship.accepted.where(friend_id: id).map(&:user)

		friends_sent_by_user | friends_sent_to_user
	end

	def pending_friends
		pending_friendships.map(&:friend)
	end

	def accepted_friends
		accepted_friendships.map(&:friend)
	end

	def rejected_friends
		rejected_friendships.map(&:friend)
	end

	def send_devise_notification(notification, *args)
		devise_mailer.send(notification, self, *args).deliver_later
	end

	def verified?
		friends.count >= 2
	end

	def saved_skippers
		saved_skipper_ids.map { |id| Skipper.find(id) }
	end

	def saved_skipper?(skipper)
		saved_skippers.map(&:id).include?(skipper.id)
	end

	def saved_skipper_ids
		Rails.cache.read(saved_skippers_key)
	end

	def saved_skippers_key
		"user-#{id}-saved-skippers"
	end
end

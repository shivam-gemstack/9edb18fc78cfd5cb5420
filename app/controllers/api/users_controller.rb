class Api::UsersController < ApplicationController
	REGEX_PATTERN = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/ 

	before_action :get_user, only: [:update, :show, :destroy]
	before_action :check_email_valid?, only: [:create,:update]

	def index
		all_users = User.all
		total_count = all_users.count		
		page = params[:page]||User::PAGE
		per_page = params[:per_page]||User::PER_PAGE
		users = all_users.paginate(page:page, per_page: per_page)		
		if users.present?
			mod = all_users.length % per_page.to_i
			pages = all_users.length / per_page.to_i
			pages+=1 if mod>0
		else
			pages = 0
		end

		render json:{users: ActiveModel::SerializableResource.new(users,each_serializer:UsersSerializer).as_json,
		meta:{
			pagination:{
				current_page: users.current_page,
				total_pages: pages.present? ? pages: "",
				per_page: per_page,
				total_count: total_count
			}
		} }
	end

	def create
		user = User.create!(user_params)
		if user.save!
			render json:{user: UsersSerializer.new(user).serializable_hash}
		else
			render json: {
				errror:"Unable to create a user"
			}
		end
	end

	def show
		render json:{user: UsersSerializer.new(@user).serializable_hash}
	end

	def update
		@user.update!(user_params)
		render json:{user: UsersSerializer.new(@user).serializable_hash}
	end

	def destroy
		@user.destroy
		render json:{message:"user deleted succesfully", user:{}}
	end

	def typehead
		users =	User.typehead(params[:input])
		render json:{users: ActiveModel::SerializableResource.new(users,each_serializer:UsersSerializer).as_json }
	end


	private
	def user_params
		params.permit(:email,:firstName,:lastName)
	end

	def get_user
		@user  = User.find(params[:id])
	end

	def check_email_valid?
		if is_email_valid? params[:email]
			true
		else
			return render json:{error:"email format is not valid"}
		end
	end

	def is_email_valid? email
    email =~REGEX_PATTERN 
	end



end

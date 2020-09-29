class Api::UsersController < ApplicationController
	before_action :get_user, only: [:update, :show, :destroy]

	def index
		all_users = User.all
		total_count = all_users.count		
		page = params[:page]||User::PAGE
		per_page = params[:per_page]||User::PER_PAGE
		users = all_users.paginate(page:page, per_page: per_page)		
		pages = all_users.length / per_page.to_i
		render json:{users: ActiveModel::SerializableResource.new(users,each_serializer:UsersSerializer).as_json,
		meta:{
			pagination:{
				current_page: users.current_page,
				total_pages:  pages,
				per_page: per_page,
				total_users_count: total_count
			}
		} }
	end

	def create
		user = User.create!(user_params)
		render json:{user: UsersSerializer.new(user).serializable_hash}
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


end

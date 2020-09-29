class Api::UsersController < ApplicationController
	before_action :get_user, only: [:update, :show, :destroy]

	def index
		users = User.all
		page = params[:page]||User::PAGE
		per_page = params[:per_page]||User::PER_PAGE
		users = users.paginate(page:page, per_page: per_page)		
		render json:{
			current_page:users.current_page,
			per_page:per_page.to_i,
			total_entries: users.total_entries,
			users: ActiveModel::SerializableResource.new(users,each_serializer:UsersSerializer).as_json
		}
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

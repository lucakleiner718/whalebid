class SessionsController < Devise::SessionsController
	def create
		user = User.find_for_database_authentication(email: params[:user][:email])
		if user.nil? || !user.valid_password?(params[:user][:password])
			flash[:notice] = 'Invalid email or password'
			redirect_to root_path
		elsif !user.nil? && user.status == "closed"
			flash[:notice] = 'Your account was cancelled!'
			redirect_to root_path
		else
			self.resource = warden.authenticate!(auth_options)

			if self.resource.player && self.resource.sign_in_count == 1
				sign_in(resource_name, resource)
				yield resource if block_given?
				flash[:notice] = 'Your new account was successfully registered!'
				respond_with resource, location: new_bid_path
			else
			    sign_in(resource_name, resource)
			    yield resource if block_given?
			    respond_with resource, location: after_sign_in_path_for(resource)
			end
		end
	end
end
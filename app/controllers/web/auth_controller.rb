module Web
    class AuthController < Web::ApplicationController
        def callback
            auth = request.env['omniauth.auth']
            user = User.find_or_create_by(email: auth.info.email) do |u|
                u.name = auth.info.name
            end
            session[:user_id] = user.id
            redirect_to root_path, notice: "You logged like #{user.name}"
        end

        def logout
            session[:user_id] = nil
            redirect_to root_path, notice: "You logout"
        end

    end
end
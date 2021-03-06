class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :require_login
  before_action :current_user

  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def current_user
    @login_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_login
    if current_user.nil?
      flash[:status] = :danger
      flash[:result_text] = "You must be logged in to view this section."
      redirect_to root_path
    end
  end

end

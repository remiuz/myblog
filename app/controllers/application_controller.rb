class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :admin?
  after_filter :prepare_unobtrusive_flash




  protected

  def admin?
    if current_user
      return current_user.is_admin?
    else
      return false
    end
  end

  def authorize
    unless admin?
      flash[:error] = "Accès non-autorisé!"
      redirect_to root_path
      false
    end
  end




end

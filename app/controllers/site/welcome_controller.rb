class Site::WelcomeController < SiteController

  def index
    @questions = Question._last_questions_(params[:page])
  end
end

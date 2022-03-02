class AdminsBackoffice::QuestionsController < AdminsBackofficeController
  before_action :set_question, only: [:edit, :update, :destroy]
  before_action :get_subjects, only: [:edit, :new]

  def index
    @questions = Question.includes(:subject).order(:subject).page(params[:page]).per(15)
  end

  def new
    @question = Question.new
  end
  
  def create
    @question = Question.new(params_question)
    if @question.save
      redirect_to admins_backoffice_questions_path, notice: "Created successfuly!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update(params_question)
      redirect_to admins_backoffice_questions_path, notice: "Updated successfuly!"
    else
      render :edit
    end
  end

  def destroy
    if @question.destroy
      redirect_to admins_backoffice_questions_path, notice: "Question removed successfuly!"
    else
      render :index
    end
  end

  private

  def params_question
    params.require(:question).permit(:description, :subject_id), answers_attributes: [:id, :description, :correct, :_destroy]
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def get_subjects
    @subjects = Subject.all
  end

end

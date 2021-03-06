class Question < ApplicationRecord

  searchkick

  belongs_to :subject, counter_cache: true, inverse_of: :questions
  has_many :answers
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true 

  # Callback
  after_create :set_statistic

  # Scopes: are searchs in DB

  scope :_search_subject_, ->(page, subject_id){
    includes(:answers, :subject).where(subject_id: subject_id).page(page).per(15)
  }

  scope :_search_, ->(page, term){
    includes(:answers, :subject).where("lower(description) LIKE ?", "%#{term.downcase}%").page(page).per(15)
  }

  scope :_last_questions_, ->(page){
    includes(:answers, :subject).order('created_at desc').page(page).per(5)
  }

  private

  def set_statistic
    AdminStatistic.set_event(AdminStatistic::EVENTS[:total_questions]) 
  end

end

namespace :dev do

  DEFAULT_PASSWORD = 123123
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc "Setting the development's environment"
  task setup: :environment do
    if Rails.env.development?

      show_spinner("Dropping database", "Droped database") { %x(rails db:drop) }

      show_spinner("Creating database", "Created database") { %x(rails db:create) }

      show_spinner("Migrating database", "Migrated database") { %x(rails db:migrate) }
      
      puts "Seeding database..."
      show_spinner("Seeding database", "Database seeded") { %x(rails dev:add_default_admin dev:add_extras_admins dev:add_default_user dev:add_subjects dev:add_questions) } 

      puts ""
      spinner = TTY::Spinner.new("[:spinner] Finishing tasks...")
      spinner.success('(Successfuly tasks!)')

    else
      puts "You are not in DEVELOPMENT environment."
    end
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona o administrador extras"
  task add_extras_admins: :environment do
    10.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona assuntos padrão"
    task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)
    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc "Adiciona perguntas e respostas"
    task add_questions: :environment do
    file_name = 'subjects.txt'
    
    Subject.all.each do |subject|
      rand(5..10).times do |i|

        params = create_question_params(subject)
        answers_array = params[:question][:answers_attributes]

        add_answers(answers_array)

        elect_true_answer(answers_array)
      
        Question.create!(params[:question])

      end
    end
  end

  private

  def create_question_params(subject = Subject.all.sample)
    { question: {
        description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
        subject: subject,
        answers_attributes: []
      }
    }
  end

  def create_answers_params(correct = false)
    { description: Faker::Lorem.sentence, 
    correct: correct }
  end

  def add_answers(answers_array = [])
    rand(2..5).times do |j|
      answers_array.push(create_answers_params)
    end
  end

  def elect_true_answer(answers_array = [])
    selected_index = rand(answers_array.size)
    answers_array[selected_index] = create_answers_params(true)
  end

  def show_spinner(msg_start, msg_end)
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}... ")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end

end

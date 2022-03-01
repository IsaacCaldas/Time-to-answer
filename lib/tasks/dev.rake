namespace :dev do

  DEFAULT_PASSWORD = 123123

  desc "Setting the development's environment"
  task setup: :environment do
    if Rails.env.development?

      show_spinner("Dropping database", "Droped database") { %x(rails db:drop) }

      show_spinner("Creating database", "Created database") { %x(rails db:create) }

      show_spinner("Migrating database", "Migrated database") { %x(rails db:migrate) }
      
      puts "Seeding database..."
      show_spinner("Seeding database", "Database seeded") { %x(rails dev:add_default_admin dev:add_default_user) } 

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

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
    email: 'user@user.com',
    password: DEFAULT_PASSWORD,
    password_confirmation: DEFAULT_PASSWORD
    )
  end

  private

  def show_spinner(msg_start, msg_end)
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}... ")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end

end

class Task::MailTest < Task::Base
  def call
    UserMailer.new("test", "constxife@yandex.ru").deliver
  end
end

class Task::Cleanup < Task::Base
  def call
    time = Time.local

    Paste.where(:will_be_deleted_at, :lt, time).each {|p| p.destroy}
  end
end

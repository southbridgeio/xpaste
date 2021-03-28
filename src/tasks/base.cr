class Task::Base
  def self.call(*args)
    new(*args).call
  end
end

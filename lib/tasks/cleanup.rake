
desc "Remove expired pastes from DB"
task cleanup: :environment do
  Paste.expired_at.destroy_all
end

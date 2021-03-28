-- +micrate Up
CREATE TABLE pastes (
  id BIGSERIAL PRIMARY KEY,
  permalink VARCHAR(255) UNIQUE NOT NULL,
  body TEXT NOT NULL,
  language VARCHAR(255) NOT NULL,
  request_info JSONB,
  auto_destroy BOOL DEFAULT FALSE NOT NULL,
  will_be_deleted_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- +micrate Down
DROP TABLE IF EXISTS pastes;

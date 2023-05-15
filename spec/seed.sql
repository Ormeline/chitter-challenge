-- Drop the comments table if it exists
DROP TABLE IF EXISTS comments;

-- Drop the peeps table if it exists
DROP TABLE IF EXISTS peeps;

-- Drop the users table if it exists
DROP TABLE IF EXISTS users;

-- Create the users table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password_digest VARCHAR(255) NOT NULL
);

TRUNCATE TABLE users;

-- Insert sample data into the users table
INSERT INTO users (username, email, password_digest) VALUES
('alice', 'alice@example.com', '$2a$12$N/3ga8ui9haxnE.M8itaUu.jlsAgSKikrlHu3.jlgQEixOTk/iFoS'), -- password is 'password'
('bob', 'bob@example.com', '$2a$12$N/3ga8ui9haxnE.M8itaUu.jlsAgSKikrlHu3.jlgQEixOTk/iFoS'),
('charlie', 'charlie@example.com', '$2a$12$N/3ga8ui9haxnE.M8itaUu.jlsAgSKikrlHu3.jlgQEixOTk/iFoS');

-- Create the peeps table
CREATE TABLE peeps (
  id SERIAL PRIMARY KEY,
  message TEXT,
  date_time TIMESTAMP,
  user_id INTEGER
);

TRUNCATE TABLE peeps;

-- Insert sample data into the peeps table
INSERT INTO peeps (message, date_time, user_id) VALUES
('Nice peep!', NOW(), 1),
('My first peep!', NOW(), 2),
('Testing, testing...', NOW(), 3);

-- Create the comments table
CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  message TEXT,
  date_time TIMESTAMP,
  peep_id INTEGER,
  user_id INTEGER
);

TRUNCATE TABLE comments;

-- Insert sample data into the comments table
INSERT INTO comments (message, date_time, peep_id, user_id) VALUES
('Nice peep!', NOW(), 1, 1),
('Great job!', NOW(), 1, 2),
('Love this!', NOW(), 1, 3),
('Awesome!', NOW(), 1, 1),
('Well done!', NOW(), 2, 2),
('Keep it up!', NOW(), 2, 3),
('Amazing!', NOW(), 2, 1),
('Impressive!', NOW(), 3, 2),
('Bravo!', NOW(), 3, 3);
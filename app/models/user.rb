require 'pg'
require 'bcrypt'

class User
  attr_accessor :id, :username, :email, :password_digest

  def initialize(attributes = {})
    @id = attributes[:id]
    @username = attributes[:username]
    @email = attributes[:email]
    @password_digest = attributes[:password_digest]
  end

  def self.all
    conn = PG.connect(dbname: 'chitter_test', user: 'ormeline')
    result = conn.exec('SELECT * FROM users')
    users = result.map do |row|
      User.new(
        id: row['id'],
        username: row['username'],
        email: row['email'],
        password_digest: row['password_digest']
      )
    end
    conn.close
    users
  end

  def self.find(id)
    conn = PG.connect(dbname: 'chitter_test', user: 'ormeline')
    result = conn.exec_params('SELECT * FROM users WHERE id = $1', [id])
    conn.close
    if result.num_tuples.zero?
      User.new
    else
      row = result.first
      User.new(
        id: row['id'],
        username: row['username'],
        email: row['email'],
        password_digest: row['password_digest']
      )
    end
  end

  def save
    conn = PG.connect(dbname: 'chitter_test', user: 'ormeline')
    if id
      conn.exec_params(
        'UPDATE users SET username = $1, email = $2, password_digest = $3 WHERE id = $4',
        [username, email, password_digest, id]
      )
    else
      result = conn.exec_params(
        'INSERT INTO users (username, email, password_digest) VALUES ($1, $2, $3) RETURNING id',
        [username, email, password_digest]
      )
      @id = result[0]['id']
    end
    conn.close
  end

  def destroy
    conn = PG.connect(dbname: 'chitter_test', user: 'ormeline')
    conn.exec_params('DELETE FROM users WHERE id = $1', [id])
    conn.close
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    conn = PG.connect(dbname: 'chitter_test', user: 'ormeline')
    result = conn.exec_params('SELECT * FROM users WHERE email = $1', [email])
    conn.close
    if result.num_tuples.zero?
      User.new
    else
      row = result.first
      user = User.new(
        id: row['id'],
        username: row['username'],
        email: row['email'],
        password_digest: row['password_digest']
      )
      if BCrypt::Password.new(user.password_digest) == password
        user
      else
        User.new
      end
    end
  end
end
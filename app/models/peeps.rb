require 'pg'

class Peep
  attr_accessor :id, :message, :date_time, :user_id, :comments

  def initialize(attributes = {})
    @id = attributes[:id]
    @message = attributes[:message]
    @date_time = attributes[:date_time]
    @user_id = attributes[:user_id]
    @comments = attributes[:comments] || []
  end

  def self.all
    conn = PG.connect(dbname: 'chitter_test', user: 'ormeline')
    result = conn.exec('SELECT * FROM peeps')
    peeps = result.map do |row|
      comments = Comment.where(peep_id: row['id'])
      Peep.new(
        id: row['id'],
        message: row['message'],
        date_time: row['date_time'],
        user_id: row['user_id'],
        comments: comments
      )
    end
    conn.close
    peeps
  end

  def self.find(id)
    conn = PG.connect(dbname: 'chitter_test', user: 'ormeline')
    result = conn.exec_params('SELECT * FROM peeps WHERE id = $1', [id])
    row = result.first
    comments = Comment.where(peep_id: row['id'])
    conn.close
    peep = Peep.new(
      id: row['id'],
      message: row['message'],
      date_time: row['date_time'],
      user_id: row['user_id'],
      comments: comments
    )
    peep
  end

  def save
    conn = PG.connect(dbname: 'chitter_test', user: 'ormeline')
    if id
      conn.exec_params(
        'UPDATE peeps SET message = $1, date_time = $2, user_id = $3 WHERE id = $4',
        [message, date_time, user_id, id]
      )
    else
      result = conn.exec_params(
        'INSERT INTO peeps (message, date_time, user_id) VALUES ($1, $2, $3) RETURNING id',
        [message, date_time, user_id]
      )
      @id = result[0]['id']
    end
    conn.close
  end

  def self.count
    conn = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
    result = conn.exec('SELECT COUNT(*) FROM peeps')
    count = result[0]['count'].to_i
    conn.close
    count
  end

  def self.last
    conn = PG.connect(dbname: 'chitter_test', user: 'ormeline')
    result = conn.exec('SELECT * FROM peeps ORDER BY date_time ASC LIMIT 1')
    row = result.first
    comments = Comment.get_by_peep_id(peep_id: row['id'])
    peep = Peep.new(
      id: row['id'],
      message: row['message'],
      date_time: row['date_time'],
      user_id: row['user_id'],
      comments: comments
    )
    conn.close
    peep
  end

def destroy
  conn = PG.connect(dbname: 'chitter_test', user: 'ormeline')
  conn.transaction do |c|
    c.exec_params('DELETE FROM comments WHERE peep_id = $1', [id])
    c.exec_params('DELETE FROM peeps WHERE id = $1', [id])
  end
  conn.close
end
end
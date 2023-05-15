require 'pg'

class Comment
  attr_accessor :id, :message, :date_time, :peep_id, :user_id

  def initialize(attributes = {})
    @id = attributes[:id]
    @message = attributes[:message]
    @date_time = attributes[:date_time]
    @peep_id = attributes[:peep_id]
    @user_id = attributes[:user_id]
  end

  def self.all
    conn = PG.connect(dbname: 'mydatabase', user: 'myuser', password: 'mypassword')
    result = conn.exec('SELECT * FROM comments')
    comments = result.map do |row|
      Comment.new(
        id: row['id'],
        message: row['message'],
        date_time: row['date_time'],
        peep_id: row['peep_id'],
        user_id: row['user_id']
      )
    end
    conn.close
    comments
  end

  def self.find(id)
    conn = PG.connect(dbname: 'chitter_test', user: 'ormeline')
    result = conn.exec_params('SELECT * FROM comments WHERE id = $1', [id])
    row = result.first
    comment = Comment.new(
      id: row['id'],
      message: row['message'],
      date_time: row['date_time'],
      peep_id: row['peep_id'],
      user_id: row['user_id']
    )
    conn.close
    comment
  end

  def save
    conn = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
    if id
      conn.exec_params(
        'UPDATE comments SET message = $1, date_time = $2, peep_id = $3, user_id = $4 WHERE id = $5',
        [message, date_time, peep_id, user_id, id]
      )
    else
      result = conn.exec_params(
        'INSERT INTO comments (message, date_time, peep_id, user_id) VALUES ($1, $2, $3, $4) RETURNING id',
        [message, date_time, peep_id, user_id]
      )
      @id = result[0]['id']
    end
    conn.close
  end

  def self.most_recent
    conn = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
    result = conn.exec('SELECT * FROM comments ORDER BY date_time DESC LIMIT 1')
    row = result.first
    comment = Comment.new(
      id: row['id'],
      message: row['message'],
      date_time: row['date_time'],
      peep_id: row['peep_id'],
      user_id: row['user_id']
    )
    conn.close
    comment
  end

  def self.count
    conn = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
    result = conn.exec('SELECT COUNT(*) FROM comments')
    count = result[0]['count'].to_i
    conn.close
    count
  end

  def update
    conn = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
    conn.exec_params(
      'UPDATE comments SET message = $1, date_time = $2, peep_id = $3, user_id = $4 WHERE id = $5',
      [message, date_time, peep_id, user_id, id]
    )
    conn.close
  end

  def self.get_by_peep_id(id)
    conn = PG.connect(dbname: 'chitter_test', user: 'ormeline')
    result = conn.exec_params('SELECT * FROM comments WHERE peep_id = $1', [id])
    conn.close
    comments = result.map { |row| Comment.new(row) }
    comments
  end

  def destroy
    conn = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
    conn.exec_params('DELETE FROM comments WHERE id = $1', [id])
    conn.close
  end

  def self.where(params)
    conn = PG.connect(dbname: 'chitter_test', user: 'ormeline')
    conditions = params.map.with_index { |(k, v), i| "#{k} = $#{i + 1}" }.join(' AND ')
    values = params.transform_keys(&:to_s).values
    result = conn.exec_params("SELECT * FROM comments WHERE #{conditions}", values)
    comments = result.map { |row| Comment.new(row) }
    conn.close
    comments
  end

  def self.exists?(id)
    conn = PG.connect(dbname: 'chitter_test', user: 'ormeline')
    result = conn.exec_params('SELECT COUNT(*) FROM comments WHERE id = $1', [id])
    count = result.first['count'].to_i
    conn.close
    count > 0
  end
end
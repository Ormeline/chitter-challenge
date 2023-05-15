module TestHelper
  def reset
    seed_sql = File.read("spec/seed.sql")
    connection = PG.connect({ host: "127.0.0.1", dbname: "chitter_test" })
    connection.exec(seed_sql)
  end
end

require 'sqlite3'
require 'pry'

class Robot

  attr_reader :id,
              :name,
              :city,
              :state,
              :department

  def initialize(robot_params)
    @name = robot_params["name"]
    @city = robot_params["city"]
    @state = robot_params["state"]
    @department = robot_params["department"]
    @database = SQLite3::Database.new('db/robot_world_development.db')
    @database.results_as_hash = true
    @id = robot_params["id"] if robot_params["id"]
  end

  def self.all
    robots = database.execute("SELECT * FROM robots")
    robots.map {|robot| Robot.new(robot)}
  end

  def self.find(id)
    robot = database.execute("SELECT * FROM robots WHERE id = ?", id.to_i).first
  end

  def self.database
    database = SQLite3::Database.new('db/robot_world_development.db')
    database.results_as_hash = true
    database
  end

  def self.update(id, robot_params)
    database.execute("UPDATE robots SET name = ?, city = ?, state = ?, department = ? WHERE id = ?;", robot_params["name"], robot_params["city"], robot_params["state"], robot_params["department"], id)
  end

  def self.destroy(id)
    database.execute("DELETE FROM robots WHERE id = ?;", id)
  end

  def self.populate_database(num_bots)
    num_bots.times do
      robot = Robot.new({"name" => Faker::Name.first_name, "city" => Faker::Lovecraft.location, "state" => Faker::Zelda.location, "department" => Faker::Lovecraft.deity})
      robot.save
    end
  end

  def save
    @database.execute("INSERT INTO robots (name, city, state, department) VALUES (?, ?, ?, ?);", @name, @city, @state, @department)
  end
end

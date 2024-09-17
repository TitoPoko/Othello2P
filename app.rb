require 'sinatra'
require 'json'
require 'aws-sdk-dynamodb'
require 'dotenv/load'
require 'logger'


Aws.config.update(
  {
  region: 'us-west-2',
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
  }
)

def setup_games_table(dynamodb)
  tables = dynamodb.list_tables.table_names       # tables is assigned an array of table_names
  unless tables.include?('Games')                 # Unless "Games" already exists...
      dynamodb.create_table({
        table_name: 'Games',
        key_schema: [
          { attribute_name: 'game_id', key_type: 'HASH' } # partition/primary key
        ],
        attribute_definitions: [
          { attribute_name: 'game_id', attribute_type: 'N' } # 'N' = Number
        ],
        provisioned_throughput: {
        read_capacity_units: 5,
        write_capacity_units: 5
      }
    })

    puts "No Games table existed, Games table created."
  else
    puts "Games table already exists."
  end

end

configure do
  set :logger, Logger.new(STDOUT)               # Set up a logger
  set :dynamodb, Aws::DynamoDB::Client.new
  setup_games_table(settings.dynamodb)
end

helpers do
  def dynamodb
    settings.dynamodb
  end
end



def get_game_id

  result = dynamodb.scan(
    {
      table_name: 'Games',
      projection_expression: 'game_id',
    }
  )

  game_ids = result.items.map { |item| item['game_id'] }

  game_ids.empty? ? 1 : game_ids.max + 1

end


def create_game(grid_size, player_1_id, player_2_id)

  content_type :json

  game_id = get_game_id.to_i

  game = {
    game_id: game_id,
    grid_size: grid_size,
    player_1_id: player_1_id,
    player_2_id: player_2_id 
  }

  result = dynamodb.put_item(
    {              
      table_name: 'Games',
      item: game
    }
  )

  game_id

end


  get '/Othello' do
    erb :index
  end

  post '/start' do

    request_body = request.body.read    # Hash of everything sent here... {grid_size: gridWidth}
    params = JSON.parse(request_body)   #parses FROM JSON

    grid_size = params['grid_size'] 
    player_1_id = params['player_1_id']
    player_2_id = params['player_2_id']

    logger.info "Player 1 ID: #{player_1_id}"   # Debugging log
    logger.info "Player 2 ID: #{player_2_id}"
    logger.info "Received Player 1 ID: #{player_1_id}"
    logger.info "Received Player 2 ID: #{player_2_id}"

    game_id = create_game(grid_size, player_1_id, player_2_id)
      #grid_layout_array = method that populates cell states (grid_size, beginning_layout)



    content_type :json    #going back to the client (not DB)
    { game_id: game_id,
      grid_size: grid_size, 
      player_1_id: player_1_id, 
      player_2_id: player_2_id 
    }.to_json
      #grid_layout_array: 
          #put in grid_layout: and send to Dynamo?
  end


=begin
   DB for MOVES (not cells)
    game_id | timestamp | player_id | cell_id
    game_id and timestamp will be compound primary 

=end
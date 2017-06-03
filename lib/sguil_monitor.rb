require 'rubygems'
require 'mysql2'
require 'json'
require 'yaml/store'
require 'net/http'
require 'uri'

$client = Mysql2::Client.new(:default_file => '/etc/mysql/debian.cnf', :database => 'securityonion_db')

$sensor_store = YAML::Store.new(File.expand_path File.dirname(__FILE__)+"/sensors.yml")
$sensors = Hash.new
$sensor_store.transaction do
	$sensor_store.roots.each do |sensor_id|
		$sensors[sensor_id] = $sensor_store[sensor_id]
	end
end

sensors_results = $client.query("SELECT DISTINCT event.sid FROM event ORDER BY event.sid asc").each do |row|
	sensor = row['sid']
	if !$sensors.key?(sensor)
		$sensors[sensor]= 0
	end
end

def write_sensors
	$sensor_store.transaction do
		$sensors.each do |key, value| 
			$sensor_store[key] = value
		end
		$sensor_store.commit
	end
end

def post_data(new_event)
	uri = URI('http://192.168.2.204:3000/events')
	http = Net::HTTP.new(uri.host, uri.port)
	req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
	req.body = new_event.to_json 
	res = http.request(req)
end

def get_events(my_client, sensor_id, start_event_id)
	statement = my_client.prepare("SELECT * FROM event WHERE event.sid = ? AND  event.cid > ? ORDER BY event.cid")
	results = statement.execute(sensor_id, start_event_id)
	new_events = [] 
	results.each do |row|
		row['event_class'] = row.delete('class')
		new_events.push(row)
		$sensors[row['sid']] = row['cid']
	end
	return new_events
end

while(true)
	sleep(10)
	$sensors.each do |key, value| 
		new_events = get_events($client, key, value)
		new_events.each do |event|
			#post_data(event)
			puts event.to_s
		end
	end
	write_sensors
end


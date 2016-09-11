#!/usr/bin/env /Users/nathankw/RailsApps/snyder_encode/bin/rails runner

#require "json" #not needed since I added this to the Gemfile and RAILS already requires all gems when using rails runner.
require "optparse"

Vendor.delete_all

options = {}
OptionParser.new do |opts|
	opts.on("--infile [INFILE]",help="Full path to input file containing JSON to import into the ENCODE sources table. This can be obtained from the URL https://www.encodeproject.org/sources/?format=json&limit=all.") do |infile|
		options[:infile] = infile
	end
end.parse!

fh = File.read(options[:infile])
json_data = JSON.parse(fh)
if json_data.has_key?("@graph")
	json_data = json_data["@graph"]
end

json_data.each do |x|
	params = {}
	params[:description] = x["description"]
	params[:title] = x["title"]
	params[:name] = x["name"]
	Vendor.create!(params)
end

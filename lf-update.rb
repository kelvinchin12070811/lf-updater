# !/usr/env/bin ruby
# frozen_string_literal: true

require 'open-uri'
require 'json'

RELEASE_URL = 'https://api.github.com/repos/gokcehan/lf/releases/latest'

puts '===== lf updater ====='
puts 'Fetching latest version...'

content = URI.open(RELEASE_URL).read
response = JSON.parse(content)
latest_version = response['tag_name'].strip

puts 'Getting local version...'

exe_path = File.join(File.dirname(__FILE__), 'lf.bin.exe')
current_version = File.exist?(exe_path) ? `"#{exe_path}" -single -version`.strip : nil

puts "\nLatest version found: #{latest_version}"
puts "Currently installed version: #{current_version}"

if latest_version == current_version
  puts "\nlf utility already updated to latest version."
  return
end

puts "\nNo lf installed currently." if current_version.nil?

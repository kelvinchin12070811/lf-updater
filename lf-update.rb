# !/usr/env/bin ruby
# frozen_string_literal: true

require 'open-uri'
require 'json'
require 'fileutils'

RELEASE_URL = 'https://api.github.com/repos/gokcehan/lf/releases/latest'
TARGET_NAME = 'lf-windows-amd64.zip'

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
puts "\nNew update available: #{latest_version}." if current_version != latest_version
puts "Do you want to #{current_version.nil? ? 'install' : 'update'} lf utility? [Y/n]"
print '> '

user_input = gets &.chomp

return if user_input.downcase != 'y'

puts "\nResolving download url..."
asset_url = response['assets'].find { |asset| asset['name'] == TARGET_NAME }['browser_download_url']
FileUtils.rm_rf('temp') if File.exist?('temp')

puts "Downloading #{TARGET_NAME}..."
Dir.chdir(File.dirname(__FILE__))
Dir.mkdir("temp") unless Dir.exists?("temp")
Dir.chdir("temp")
`curl -OL #{asset_url}`
`7z x #{TARGET_NAME}`

puts "Removing old installation..." if File.exist?('lf.bin.exe')
Dir.chdir('..')
FileUtils.remove_file('lf.bin.exe') if File.exist?('lf.bin.exe')

puts "Installing #{TARGET_NAME}..."
FileUtils.cp('temp/lf.exe', './lf.bin.exe')

puts "Cleaning up..."
FileUtils.rm_rf('temp')

puts "Done!"
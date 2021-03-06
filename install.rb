#require 'fileutils'
#
#PLUGIN_WD = "sexy-select"
#
#def define_files
#  [ 
#    {:name => "#{PLUGIN_WD}.css", :destination => "public/stylesheets"},
#    {:name => "#{PLUGIN_WD}.js", :destination => "public/javascripts"},
#    {:name => "downarrow.png", :destination => "public/images/#{PLUGIN_WD}", :mkdir => true}
#  ]
#end
#
#def copy_files(files)
#  for file in files do
#    if file[:mkdir]
#      if File.exists?("#{RAILS_ROOT}/#{file[:destination]}/")
#        puts "\t#{file[:destination]}/ already exists"
#      else
#        puts "\tcreate #{file[:destination]}"
#        FileUtils.mkdir("#{RAILS_ROOT}/#{file[:destination]}/")
#      end
#    end
#
#    if File.exists?("#{RAILS_ROOT}/#{file[:destination]}/#{file[:name]}")
#      if FileUtils.compare_file("#{RAILS_ROOT}/#{file[:destination]}/#{file[:name]}", "#{RAILS_ROOT}/vendor/plugins/#{PLUGIN_WD}/lib/#{file[:name]}")
#        puts "\tidentical /#{file[:destination]}/#{file[:name]}, /vendor/plugins/#{PLUGIN_WD}/lib/#{file[:name]}"
#      else
#        puts "\tdifferent /#{file[:destination]}/#{file[:name]}, /vendor/plugins/#{PLUGIN_WD}/lib/#{file[:name]}"
#        puts "Do you wish to overwrite the existing file? (y/N)"
#        if !gets.match(/^y/i).nil?
#          puts "\toverwrite /#{file[:destination]}/#{file[:name]}"
#          FileUtils.cp("#{RAILS_ROOT}/vendor/plugins/#{PLUGIN_WD}/lib/#{file[:name]}","#{RAILS_ROOT}/#{file[:destination]}/")
#        end
#      end
#    else
#      puts "\tcreate #{file[:destination]}/#{file[:name]}"
#      FileUtils.cp("#{RAILS_ROOT}/vendor/plugins/#{PLUGIN_WD}/lib/#{file[:name]}","#{RAILS_ROOT}/#{file[:destination]}/")
#    end
#  end
#end
#
#copy_files(define_files)
#puts "Installation Complete."

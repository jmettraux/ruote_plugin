
#
# a set of Ruote (OpenWFEru) related tasks.
#
#   rake ruote:install
#
# will grab all the Ruote source code (with Rufus dependencies) and place
# it under vendor/ruote_plugin/lib
#
#   rake ruote:gem_install
#
# will do the equivalent, but instead of downloading the source code, it will
# install the latest Ruote (and Rufus) gems.
#
# Note that rake ruote:install will nevertheless install atom-tools and
# ruby_parser as gems.
#
namespace :ruote do

  RUFUSES = %w{
    dollar lru mnemo scheduler verbs treechecker
  }.collect { |e| "rufus-#{e}" }

  RUOTE_PLUGIN_LIB = File.dirname(__FILE__) + '/../lib_ruote'

  #
  # do use either :install_workflow_engine either :install_dependency_gems
  # but not both
  #

  desc(
    "Installs under vendor/ruote_plugin/lib the latest source of Ruote " +
    "(OpenWFEru) (and required subprojects).")
  task :install => :get_from_github do

    sh 'sudo gem install --no-rdoc --no-ri ruby_parser'
    sh 'sudo gem install --no-rdoc --no-ri atom-tools'
  end

  task :get_from_github do

    mkdir 'tmp' unless File.exists?('tmp')

    rm_fr RUOTE_PLUGIN_LIB
    mkdir RUOTE_PLUGIN_LIB

    RUFUSES.each { |e| git_clone(e) }
    git_clone 'ruote'
  end

  def rm_fr (dir_or_file)
    rm_r(dir_or_file) if File.exists?(dir_or_file)
  end

  def git_clone (elt)

    chdir 'tmp' do
      sh "git clone git://github.com/jmettraux/#{elt}.git"
    end
    cp_r "tmp/#{elt}/lib/.", "#{RUOTE_PLUGIN_LIB}/"
    rm_r "tmp/#{elt}"
  end

  desc(
    "Installs the Ruote (OpenWFEru) gems and there dependencies")
  task :gem_install do

    GEMS = RUFUSES.dup

    GEMS << 'ruote'
    GEMS << 'atom-tools'

    sh "sudo gem install --no-rdoc --no-ri #{GEMS.join(' ')}"

    puts
    puts "installed gems  #{GEMS.join(' ')}"
    puts
  end

  desc(
    "Fetches the latest ruote-fluo .js scripts from http://github.com " +
    "and places them in public/javascripts")
  task :fetch_fluo do

    require 'open-uri'

    branch = 'master'

    %w{ fluo-can.js fluo-json.js fluo-tred.js }.each do |script|
      open("http://github.com/jmettraux/ruote-fluo/tree/#{branch}/public/js/#{script}?raw=true") do |r|
        File.open("public/javascripts/#{script}", 'w') { |f| f.write(r.read) }
        puts ".. wrote public/javascripts/#{script}"
      end
    end
  end
end


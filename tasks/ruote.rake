
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
# rogue_parser as gems.
#
namespace :ruote do

  RUFUSES = %w{
    dollar eval lru mnemo scheduler verbs treechecker
  }.collect { |e| "rufus-#{e}" }

  RUOTE_PLUGIN_LIB = File.dirname(__FILE__) + '/../lib'

  #
  # do use either :install_workflow_engine either :install_dependency_gems
  # but not both
  #

  desc(
    "Installs under vendor/ruote_plugin/lib the latest source of Ruote " +
    "(OpenWFEru) (and required subprojects).")
  task :install => :get_from_github do

    sh 'sudo gem install --no-rdoc --no-ri rogue_parser'
    sh 'sudo gem install --no-rdoc --no-ri atom-tools'
  end

  task :get_from_github do

    mkdir 'tmp' unless File.exists?('tmp')

    rm_fr "#{RUOTE_PLUGIN_LIB}/openwfe"
    rm_fr "#{RUOTE_PLUGIN_LIB}/rufus*"

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

  desc "Installes the Ruote (OpenWFEru) gems and there dependencies"
  task :gem_install do

    GEMS = RUFUSES.dup

    GEMS << 'ruote'
    GEMS << 'atom-tools'

    sh "sudo gem install --no-rdoc --no-ri #{GEMS.join(' ')}"

    puts
    puts "installed gems  #{GEMS.join(' ')}"
    puts
  end
end


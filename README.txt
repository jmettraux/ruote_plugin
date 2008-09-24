
= ruote_plugin


== Overview

Minimal integration of Ruote into a Ruby on Rails application

Once installed, the plugin will add a ruote_engine method to your controllers so that you get access to workflow engine quite easily.

You can also access the engine directly via 

  RuotePlugin.ruote_engine

Note that the plugin also adds a shutdown hook to your application to make sure the workflow engine gets stopped in a clean way.


== Usage

Two steps : getting the plugin and then using it to generate the db migrations necessary to the Ruote workflow and bpm engine.

=== get the plugin into vendor/plugins

Three ways to do that. (a) is the most straightforward. If you need to track the development of the ruote_plugin (b) or (c) are probably better.

(a) the script/plugin way

in your Rails application do :

  script/plugin install git://github.com/jmettraux/ruote_plugin.git

(b) the .git way

  cd vendor/plugins
  git clone git://github.com/jmettraux/ruote_plugin.git

(c) the git submodule way

your Rails application needs to be a git working copy

see http://woss.name/2008/04/09/using-git-submodules-to-track-vendorrails/

  git submodule add git://github.com/jmettraux/ruote_plugin.git vendor/plugins/ruote_plugin

=== generate the migrations

Two variants here, 'basic' or 'all'. I recommend 'basic', it will create the tables for workitems and for history. 'all' will create tables for expression persistence. If your admin is more confortable with database backups than with filesystem backups then 'all' (b) is for you.

The migrations will be found under db/migrate/ as should be.

(a) 'basic'

  script/generate ruote_plugin basic

(b) 'all'

  script/generate ruote_plugin all


=== install Ruote and its dependencies

The plugin comes with 2 rake tasks for installing the workflow engine itself, either inside of vendor/ruote/ (and vendor/rufus/) with all its dependencies, either as a gem (plus gem dependencies).

  rake ruote:install

or

  rake ruote:gem_install


== Links

http://openwferu.rubyforge.org
http://rubyforge.org/projects/openwferu
http://github.com/jmettraux/ruote_plugin

ruote-web2 is the first 'client' application of this plugin :
http://github.com/jmettraux/ruote-web2


== Feedback

user mailing list :        http://groups.google.com/group/openwferu-users
developers mailing list :  http://groups.google.com/group/openwferu-dev

issue tracker :            http://rubyforge.org/tracker/?atid=10023&group_id=2609&func=browse

irc :                      irc.freenode.net #ruote


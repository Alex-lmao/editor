require 'rubygems'
require 'gtk3'
# require 'libglade2' #you don't need this anymore

builder = Gtk::Builder.new
builder.add_from_file("~/Documents/programming_challenges/editor/builder.ui")
builder.connect_signals {|handler| method(handler) }

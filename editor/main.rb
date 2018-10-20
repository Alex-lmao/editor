#!/usr/bin/ruby

require 'gtk3'

$file_open = false
$opened_file = ""

class RubyApp < Gtk::Window

  def initialize
    super
    init_ui
  end

  def get_folder(folder)
    a=''
    Dir.chdir(File.expand_path(folder)) {
    dialog = Gtk::FileChooserDialog.new(
      :title => "Title",
      :parent => nil,
      :action => Gtk::FileChooserAction::OPEN,
      :buttons => [[Gtk::Stock::OPEN, Gtk::ResponseType::ACCEPT], [Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL]])
    if dialog.run == Gtk::ResponseType::ACCEPT
      a=dialog.filename
      $file_open = true
      $opened_file = a
    end
    dialog.destroy }
    return a
  end

  def load_file(folder)
    path = get_folder(folder)
    puts "Opening file: " + path
    file = File.open(path, "r")
    contents = file.read

    text_buffer = Gtk::TextBuffer.new
    #text_buffer.insert_at_cursor(contents)
    text_buffer.set_text(contents)
    return text_buffer
  end

  def save_file(text)
    File.open($opened_file, "w"){|file| file.write(text)}
  end

  def init_ui

    builder_file = "#{File.expand_path(File.dirname(__FILE__))}/test2.ui"

    # Builder used to read xml file
    builder = Gtk::Builder.new(:file => builder_file)

    builder.connect_signals {|handler| method(handler) }

    window = builder.get_object("window")
    window.signal_connect("destroy"){Gtk.main_quit}

    text_area = builder.get_object("text_area")

    load_button = builder.get_object("load_button")
    load_button.signal_connect("clicked"){text_area.set_buffer(load_file("~"))} # TODO load file

    save_button = builder.get_object("save_button")
    save_button.signal_connect("clicked"){
      if $file_open
        save_file(text_area.buffer.text)
      end} # TODO save file

    exit_button = builder.get_object("exit_button")
    exit_button.signal_connect("clicked"){Gtk.main_quit}

    window.set_title "Alex editor"
    window.set_default_size 640, 480
    window.window_position = :center
    window.show_all
  end
end


 window = RubyApp.new
Gtk.main

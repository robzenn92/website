require_relative 'generator'

Slim::Engine.set_options pretty: true

module Reference
  class App < Sinatra::Application
    set :root,          File.expand_path(File.dirname(__FILE__))
    set :public_folder, Proc.new { File.join(root, 'static') }
    set :views,         Proc.new { File.join(root, 'views') }

    set :markdown, {
      renderer:           Generator,
      fenced_code_blocks: true,
      layout_engine:      :slim,
      layout:             :layout
    }

    # Automatically set up routes for all views

    engines = {'.md' => :markdown, '.slim' => :slim}

    views = Dir["#{settings.views}/**/*{#{engines.keys.join(',')}}"].map do |file|
      ext = File.extname(file)
      {
        path: file[settings.views.length...-ext.length],
        ext: ext
      }
    end.reject do |view|
      view[:path] =~ /layout$/
    end

    views.each do |view|
      get view[:path] do
        self.send(engines[view[:ext]], view[:path].to_sym)
      end
      if view[:path] == '/index'
        get '/' do
          self.send(engines[view[:ext]], view[:path].to_sym)
        end
      end
    end
  end
end

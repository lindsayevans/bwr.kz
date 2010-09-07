require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'RMagick'
require 'rvg/rvg'

FORMATS = {
  "png" => "png",
  "gif" => "gif",
  "jpg" => "jpeg"
}


set :haml, {:format => :html5, :attr_wrapper => '"' }

## Index
get '/' do
  haml :index
end


## Fakeimage

get '/i/?' do
  # TODO: pretty index, JS URL/img builder
  "<h1>bwr.kz</h1><h2>fakeimage</h2><p>Please see the README (specifically the 'Use' section) at <a href='http://github.com/xxx/fakeimage'>http://github.com/xxx/fakeimage</a> for usage info so I don't have a chance to let one of the copies get out of date.</p><p>Example: <img src='/i/243x350.gif?color=DeepPink&amp;textcolor=!00FF00' /></p><p>Code: <code>&lt;img src='http://#{request.host_with_port}/i/243x350.gif?color=DeepPink&amp;amp;textcolor=!00FF00' /&gt;</code>"
end

get '/i/:size' do
  begin

    # Cache that badboy
    response.headers['Cache-Control'] = 'public, max-age=300'

    wh, format = params[:size].downcase.split('.')
    format = FORMATS[format] || 'png'

    # TODO: map standard sizes to names

    width, height = wh.split('x').map { |wat| wat.to_i }

    height = width unless height

    color = color_convert(params[:color]) || 'grey69'
    text_color = color_convert(params[:textcolor]) || 'black'

    rvg = Magick::RVG.new(width, height).viewbox(0, 0, width, height) do |canvas|
      canvas.background_fill = color
    end

    # TODO: add borders if specified

    img = rvg.draw

    img.format = format

    drawable = Magick::Draw.new
    drawable.pointsize = width / 10
    drawable.font = ("./DroidSans.ttf")
    drawable.fill = text_color
    drawable.gravity = Magick::CenterGravity
    drawable.annotate(img, 0, 0, 0, 0, "#{width} x #{height}")

    content_type "image/#{format}"
    img.to_blob

  rescue Exception => e
    "<p>Something broke.  You can try <a href='/i/200x200'>this simple test</a>. If this error occurs there as well, you are probably missing app dependencies. Make sure RMagick is installed correctly. If the test works, you are probably passing bad params in the url.</p><p>Use this thing like http://host:port/200x300, or add color and textcolor params to decide color.</p><p>Error is: [<code>#{e}</code>]</p>"
  end

end

private

def color_convert(original)
  original.tr('!', '#')
  if original
    if original.index('!') == 0
      original.tr('!', '#')
    else
      original
    end
  end
end

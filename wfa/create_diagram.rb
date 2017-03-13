require 'gruff'

def create_diagram(name, data)
  labels = {}
  data.each_with_index{|c,i| labels[i] = c.first.to_s}
  data = data.map {|x,y| y}
  g = Gruff::Bar.new(1000)
  g.title = 'No Title'
  g.hide_title = true
  g.hide_legend = true
  g.margins = g.legend_margin = 0
  g.theme = Gruff::Themes::GREYSCALE
  g.labels = labels
  g.data :Legend, data
  g.write "output/#{name}.png"
end

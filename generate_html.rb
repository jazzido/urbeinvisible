require 'erb'
require 'json'
require 'ostruct'

def render_erb(template, locals)
  ERB.new(template).result(OpenStruct.new(locals).instance_eval { binding })
end

puts render_erb(File.open('./site_template.html.erb').read,
                :sections => JSON.parse(File.open('./data.json').read))

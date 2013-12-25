# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open3'
require 'json'
require 'pp'

content = {}

h = Nokogiri::HTML(File.open('./ciudades.html'))
secciones = h.xpath("//span[@class='s4' and contains(text(), 'LAS CIUDADES')]")

CIUDADES = ["Diomira", "Isadora", "Dorotea", "Zaira", "Anastasia", "Tamara", "Zora", "Despina", "Isaura", "Maurilia", "Fedora", "Zoe", "Zenobia", "Eufemia", "Zobeida", "Ipazia", "Armilla", "Cloe", "Valdrada", "Olivia", "Sofronia", "Eutropia", "Zemrude", "Aglaura", "Ottavia", "Ersilia", "Baucis", "Leandra", "Melania", "Smeraldina", "Fílides", "Pirra", "Mrgara", "Getulia", "Adelma", "Eudossia", "Moriana", "Clarice", "Eusapia", "Bersabea", "Leonia", "Irene", "Argia", "Teda", "Trude", "Olinda", "Laudomia", "Perinzia", "Procopia", "Raissa", "Andria", "Cecilia", "Marozia", "Pentesilea", "Teodora", "Berenice", "Tecla", "Zirma"]

secciones.each do |s|
  unless s.text =~ /(LAS CIUDADES [A-Z ]+\. \d+)/
    next
  end
  header = $1

  e = h.xpath("//span[@class='s6' and contains(text(), '#{header}')]/../..")[0]
  content[header] = ''
  while true do
    e = e.next_element
    if e.nil? || e.css('span.s6').size > 0
      break
    end
    content[header] << e.css('span.s7').map(&:text).join(' ')
  end
end

content.each do |header, text|
  Open3.popen3("/Users/manuel/Downloads/apache-opennlp-1.5.3/bin/opennlp SentenceDetector /Users/manuel/Downloads/pt-sent.bin") do |i, o, e, t|
    i.write text
    i.close

    content[header] = {'text' => text}
    content[header]['sentences'] = []

    city = CIUDADES.find { |c| text.include? c }
    content[header]['city'] = city
    CIUDADES.delete city

    o.read.each_line do |line|
      l = line.strip
      unless l.empty?
        content[header]['sentences'] << l
      end
    end
  end
end

puts JSON.pretty_generate(content)

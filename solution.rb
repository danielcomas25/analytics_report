#!/usr/bin/ruby
require 'csv'
options = Hash.new

data = CSV.read( 'input.csv', { headers:           true,
    converters:        :numeric,
    header_converters: :symbol }.merge(options) )

maximum_revenue = data
                    .max_by { |row| row[2]}

maximum_impression = data
                    .max_by {|row| row[1]}

maximum_cpm = data
            .max_by {|row| 1000 * row[2]/row[1]}

cpm_sorted = data
        .map {|row| row.push((1000 * row[2]/row[1]).round(2))}
            .sort_by { |row|  row[3] }
                .reverse 

## Plain text
puts    "##############\n# PLAIN TEXT #\n##############\n"
plain_text = "*** Winners ***
The website with the highest revenue is: #{maximum_revenue[0]}
The website with the highest impressions is: #{maximum_impression[0]}
The website with the highest cpm is: #{maximum_cpm[0]}

*** cpm ***
"
cpm_sorted.each do |cpm| 
    plain_text<< "- #{cpm[0]}: #{cpm[3]}\n" 
end

puts plain_text + "\n\n"

## Create Text file

file_txt = File.open("output.txt", "w")
file_txt.puts plain_text
file_txt.close

## HTML
puts "########\n# HTML #\n########"
html = "<h1>Winners</h1>
<ul>
  <li>The website with the highest revenue is: #{maximum_revenue[0]}</li>
  <li>The website with the highest impressions is: #{maximum_impression[0]}</li>
  <li>The website with the highest cpm is: #{maximum_cpm[0]}</li>
</ul>

<h1>cpm</h1>
<ul>\n"
cpm_sorted.each do |cpm| 
    html<< "<li>#{cpm[0]}: #{cpm[3]}</li>\n" 
end
html << "</ul>\n"
print html

## Create HTML file

file_html = File.open("output.html", "w")
file_html.puts html
file_html.close

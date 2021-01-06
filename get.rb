require 'nokogiri'
require 'httparty'

url = 'https://www.cdph.ca.gov/Programs/CID/DCDC/Pages/COVID-19/VaccineDoses.aspx'

#file = File.read('vax.html')
file = HTTParty.get(url)

document = Nokogiri::HTML.parse(file)

dt = Date.today

tbls = document.xpath('//*/table[contains(string(), "Region of Administering Provider")]')
tbl = tbls[0]

counts = {}
tbl.xpath('*/tr').each do |tr|
    counts[tr.children[0].text] = tr.children[1].text
end
File.open("#{dt}.json", 'w') do |f|
  f.write counts.to_json
end

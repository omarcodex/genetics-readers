# for cleaning some 23andme data
require 'csv'
require 'net/http'
require 'nokogiri'

exit unless infile = ARGV[0]
if ARGV[1] && ARGV[1] == '--ripgenes'
    ripgenes = true
end

exports = Hash.new
headers = ["snpID","chromosome","position","genotype","gene name"]

File.open(infile, 'r') do |file|
    file.each_line do |line|
        if !line.match(/#/)
            rsid, chrom, position, genotype = line.split("\t")
            if genotype.match(/\r\n/) # perform first-pass cleanup
                genotype.gsub!(/\r\n/,"")
            end
            exports[rsid] = [chrom, position, genotype]
        end
    end
end

if ripgenes
    count = 0
    exports.each do |name, infos|
        next unless name.match(/^rs/)
        puts "looking at! #{name}....#{infos}"
        break if count >= 100
        url = "https://www.ncbi.nlm.nih.gov/snp/#{name.strip}"
        raw_page = Net::HTTP.get(URI.parse(url))
        raw_page_nokogiri = Nokogiri::HTML(raw_page)
        genename = raw_page_nokogiri.css('.sect_heading')[1].css('a').text # note this may change
        if genename
            puts "got one!"
            puts genename
            infos.push(genename)
            count += 1
        end
    end
end

outfile = "#{infile}_as-csv.csv"
CSV.open(outfile, 'w') do |csv|
    csv << headers
    exports.each do |key, array|
        csv << [key.to_s] + array
    end
end
puts 'k thanks, bye!'
exit

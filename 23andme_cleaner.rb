# input is the raw file from 23andme
# this will retrieve the gene name from the rsID
# and export for gene names that are found in the list

# https://github.com/omarcodex

require 'csv'
require 'net/http'
require 'nokogiri'

exit unless infile = ARGV[0]
if ARGV[1] && ARGV[1] == '--ripgenes'
    ripgenes = true
end

if ARGV.include?("--immune")
  immune_filter = true
end

immune_genes_dict = [
          "ATXN2",
          "CCR5",
          "SH2B3",
          "HLA-A",
          "HLA-B",
        ]


summary = Hash.new
headers = ["snpID","chromosome","position","genotype","gene name"]

File.open(infile, 'r') do |file|
    file.each_line do |line|
        if !line.match(/#/)
            rsid, chrom, position, genotype = line.split("\t")
            if genotype.match(/\r\n/) # perform first-pass cleanup
                genotype.gsub!(/\r\n/,"")
            end
            summary[rsid] = [chrom, position, genotype]
        end
    end
end

exports = Hash.new
if ripgenes
    count = 0
    summary.each do |name, infos|
        next unless name.match(/^rs/)
        break if count >= 10 # demo
        url = "https://www.ncbi.nlm.nih.gov/snp/#{name.strip}"
        raw_page = Net::HTTP.get(URI.parse(url))
        raw_page_nokogiri = Nokogiri::HTML(raw_page)
        genename = raw_page_nokogiri.css('.sect_heading')[1].css('a').text # note this may change
        if genename
            count += 1
            unless (immune_filter && !immune_genes_dict.include?(genename))
                infos.push(genename)
            end
            exports.merge!({ name => infos })
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
puts "Done..."
exit

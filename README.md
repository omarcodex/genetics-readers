# genetics consumer information readers

The file `23andme_cleaner.rb` can be used to turn your tab-separated data from 23andme to a comma separated list. It's prettier that way. Also, you can add a flag (`--ripgenes`) to pull in the gene name from the Web. It's not meant to be thorough, but rather, quick and dirty.

example usage: ruby gene_reader.rb export_23andme.txt --ripgenes

Cheers-

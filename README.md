# genetics consumer information readers

The file `23andme_cleaner.rb` can be used to turn your tab-separated data from 23andme to a comma separated list. Also, you can add a flag (`--ripgenes`) to pull in the gene name from the Web. It's not meant to be thorough, but rather, quick and dirty. 

Please note that right now it's limited to 100 examples due to the long lengths of the lists!

Example:
```ruby 23andme_cleaner.rb export_23andme.txt --ripgenes```

Stay tuned!

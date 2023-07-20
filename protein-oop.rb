# Simulating gene expression toggling using OOP

class Gene
  attr_accessor :expression, :locked
  def initialize(ex)
    @expression = ex
    @locked = true
  end
  def express
    puts "expressing #{@expression}..." unless locked
    @expression unless locked
  end
end

class ProteinComplex
  attr_accessor :name, :protein_template, :protein_complex
  def initialize(name, protein_template)
    @name = name
    @protein_template = protein_template
    @protein_complex = protein_template.keys.zip([nil]).to_h
  end

  def gobble_protein(p)
    puts "gobbling #{p} into #{protein_template}...."
    if protein_template.key(p)

      protein_complex[protein_template.key(p)] = p
      protein_template.delete(protein_template.key(p))

      if protein_template.empty?
        protein_complex
      end
    end
  end
end

a = ProteinComplex.new("hemoglobin-ish", {0=>"alpha-globin", 1=>"beta-globin", 2=>"delta-globin", 3=>"quattro-goblin"})

x = Gene.new("alpha-globin")
y = Gene.new("beta-globin")
z = Gene.new("delta-globin")

puts "#{a.name} has the protein template: #{a.protein_template}. Can you fill it in?\n"

20.times do
  puts
  "Available genes and their coiled status (type number to turn on/off):"
  [x,y,z].each do |gene|
    puts "#{gene.expression}: #{gene.locked ? 'locked' : 'reading' }"
  end
  u = gets.chomp

  dict = {
    "1" => x,
    "2" => y,
    "3" => z
  }

  if dict[u]
    dict[u].locked = !dict[u].locked
  else
    puts "No item for #{u}...."
  end

  [x,y,z].each do |g|
    puts "gobbling protein..."
    if a.gobble_protein(g.express)
      puts "#{a.name} has the proteins...#{a.protein_complex}"
      puts "#{a.name} complete! Goodbye"
      exit
    end
  end
end

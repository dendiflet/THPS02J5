require 'launchy'
require 'pry'

ARGV

def check_if_user_give_imput
	abort("cette fonction requiere des paramètres.\n 
		veuillez indiquer le nombre de la semaine,\n 
		puis le nunmero d jour et enfin, c si il y a besoin d'un dossier de corrections") if ARGV.empty?
	return ARGV.empty?
end

def folder_creation(name)
  Dir.mkdir(name)
end

#création des dossiers
def folder_structure
	#création du du dossier du jour et du sodssier lib
  puts "le dossier du jours va etre créé et s'appelle " + $days_folder_template = "THP#{ARGV[0]}J#{ARGV[1]}"
  folder_creation("#{$days_folder_template}")
  folder_creation("#{$days_folder_template}/lib")
  #crée un dossier correction si besoin
  if ARGV[2] == "c"
	  puts "un dossier corrections se crée"
	  folder_creation("#{$days_folder_template}/futur correct")
  end
  return $days_folder_template
end

#lance rspec init dans le dossier du jour
def rspec
	Dir.chdir("#{$days_folder_template}/") do 
    system ("rspec --init")
  end
end
############## tout ca fonctionne################

#récuperataion du nom du fichier du jours et création de la structure
#$days_folder_template = folder_structure

#création des fichiers gitignore et gemfile
def files_creation

	$days_folder_template = "THP#{ARGV[0]}J#{ARGV[1]}"

  #création du programme template
  puts "création du temlplate.rb"
  template_rb = File.open("#{$days_folder_template}/lib/template.rb", "w")
  template_rb.puts("#{"#"*30}   REQUIRED    #{"#"*30}\n
  	require 'pry'\n
  	#require 'launchy'\n
  	#require 'nokogiri'\n
  	#require 'open-uri'\n
  	#{"#"*30}#{"#"*30}")
  #ajouter ici les gems en option
  template_rb.close

  puts "création d'un fichier template pour les tests spec"
  template_spec = File.open("#{$days_folder_template}/spec/template_spec.rb", "w")
  template_spec.puts("#appel du fichier a tester\nrequire_relative '../lib/nom_du_fichier' #sans extension\n\n##############  les TESTS   ##################\n\n#voici une structure de test basique\ndescribe \"blablabla\" do\n	it \"blablabla\" do\n		expect(fonction?(arguments)).to eq(resultat)\n	end\nend\n\n#A toi de jouer")
  template_spec.close



	#création du readme
  puts "création du readme"
	readme = File.open("#{$days_folder_template}/README.md", "w") 
	readme.puts("si tu vois cette phrase, c'est que ce fichier a été créer automatiquement\n
		Iannis Bretin, session n°7 de The Hacking project !\
		repo du jour")
  readme.close

  #dans le gitignore le .env et aussi le fichier mac ds_store
  gitignore = File.open("#{$days_folder_template}/.gitignore", "w")
  gitignore.puts("#pensez a ajouter manuellement les fichiers qui ne doivent pas etre push sur github !\n \n.env\n.DS_Store\n/lib/template.rb \nspec/templates_spec.rb \n \n")
  gitignore.close

  #création du .gemfiles
  gemfile = File.open("#{$days_folder_template}/.Gemfiles", "w")
  gemfile.puts ("source \"https://rubygems.org\"\n  ruby '2.5.1'\n  gem 'rspec'\n  gem 'pry'\n  gem 'rubocop', '~> 0.57.2' \n  #gem 'nokogiri'\n  #gem 'dotenv' \n \n####################  PENSER A AJOUTER LES AUTRES GEM NÉCÉSSAIRES MANUELLEMENT SVP    ######################\n #################### ou les décocher ################")
  gemfile.close

  #création du fichier rubocop pour pouvoir faire relire son code
  rubo_file = File.open("#{$days_folder_template}/.rubocop.yml", "w")
  rubo_file.puts("inherit_from:\n  - http://relaxed.ruby.style/rubocop.yml\n\nAllCops:\n DisplayStyleGuide: true\n DisplayCopNames: true\n Exclude:\n  - 'db/schema.rb'\n  - 'vendor/**/*'\n  - 'config/environments/*.rb'\n  - 'bin/*'\n\nRails:\n Enabled: True\n\nMetrics/BlockLength:\n Exclude:\n  - 'spec/**/*.rb'\n  - 'Guardfile'\n  - 'vendor/bundle'\n")
  rubo_file.close

  #.env ou pas? + creation
  ARGV.clear 				#pour pouvoir utiliser gets.chomp
  puts "faut-il un .env ? entrer = nom ; anithing for imput = yes"
  print "->  "
  yon = gets.chomp.to_s
  if  yon != nil
  	puts "un fichier de clef d'acces est crée : \".env\" "
    env = File.open("#{$days_folder_template}/.env", "w")
    env.puts(
"##########################   METTRE SES CLEFS D'ACCES ICI   ########################\n#####################   PENSER A AJOUTER \"   require 'dotenv'  \" au programme ruby #################\n#attention au nom des variables ;-)")
    env.close
  end
end





def perform
	
	imput_y_n = check_if_user_give_imput
	puts "#{imput_y_n}"
	if imput_y_n != true
	  $days_folder_template = folder_structure
	  rspec
	  files_creation
  else 
  	puts "rien a été créer"
  end
end

perform

#Launchy.open("https://www.thehackingproject.org/dashboard?locale=fr")

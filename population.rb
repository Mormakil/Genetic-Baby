require_relative "programme"
require_relative "operateur"

class Population
	
	@@nbgene =0
	@@taillepopu = 0
	@@nbpatients = 0
	@@terminaux = [65,1]
	@@operateurs = nil
	@@foncfit =""
	@@mode = {"full" => 'f', "growth" => 'g', "ramped" => 'r'}
	
	def self.ecrire_nbgene
		@@nbgene = Integer(gets)
	end
	
	def self.ecrire_taillepopu
		@@taillepopu = Integer(gets)
	end
	
	def self.ecrire_nbpatients(n)
		@@nbpatients = n
	end
  
	def self.ecrire_terminaux(terminaux)
		@@terminaux = terminaux
	end
	
	def self.ecrire_operateurs(operateurs)
		@@operateurs = operateurs
	end
  
	def self.nbgene
		@@nbgene
	end
	
	def self.taillepopu
		@@taillepopu
	end
	
	def self.nbpatients
		@@nbpatients
	end
	
	def self.operateurs
		@@operateurs
	end
	
	def self.terminaux
		@@terminaux
	end
	
	def self.ecrireFonctionFitness(chemin)
		begin
			fit = File.open(chemin,"r")	
			raise "fitness.txt ne s'est pas ouvert"
			@@foncfit = fit.gets
		rescue
			@@foncfit = "self.nbpatientsok.to_f / self.nbpatientstestes.to_f"
		end
	end
	
	def self.afficherFonctionFitness(fichier)
		fichier.puts("Notre fonction fitness : " + @@foncfit)
	end
	
	def self.donnerFonctionFitness
		@@foncfit
	end
	
	attr_accessor :niemegeneration
	
	def initialize(numerogeneration)
		@niemegeneration = numerogeneration
		@tableaupopulation = Array.new(Population.taillepopu)
		
		# on crée l'ensemble prêt à recevoir chaque programme
		0.upto ((Population.taillepopu) -1) do |i|
			@tableaupopulation[i] = Programme.new(Tree.new(nil),numerogeneration,i)
			i += 1
		end
	
	end
	
	########## Cette première génération peut-être générée selon plusieurs modes #########
	########## Growth : générations uniquement d'arbres incomplets #######################
	########## Full : génération d'arbres complets uniquement ############################
	########## Ramped half and half : un mix des deux, le plus commun ####################
	
	def premiereGeneration(profondeur,mode)
		case mode
		when 'f'	
			0.upto ((Population.taillepopu) -1) do |i|
				@tableaupopulation[i].generationSpontaneeFull(1,profondeur,Population.operateurs,Population.terminaux)
				i += 1
			end
		when 'g'
			0.upto ((Population.taillepopu) -1) do |i|
				@tableaupopulation[i].generationSpontaneeGrowth(1,profondeur,Population.operateurs,Population.terminaux)
				i += 1
			end
		else
			0.upto ((Population.taillepopu) -1) do |i|
				@tableaupopulation[i].generationSpontaneeRamped(1,profondeur,Population.operateurs,Population.terminaux,i)
				i += 1
			end
		end
	end
	
	def mutation(prog)
	end
	
	def crossmatch(prog1,prog2)
	end
	
	# génère une population
	# A n1, la population est générée aléatoirement
	# A n>1, on génère en fonction de règles bien précises (tournoi, sélection, random)
	def genererPopulation(niemegeneration,mode,fichier)
		if @niemegeneration ==1 
			fichier.print("et c'est parti \n")
		else
			# ici c'est parti pour la génération en nieme génération
		end
	end
	
	
	def donnerIndividu(i)
		return @tableaupopulation[i]
	end
	
	def afficherGeneration(fichier)
		fichier.puts(@niemegeneration)
	end
	
	def inscritElu(fichier)
		fichier.print("prout\n")
	end
	
	def affichelelu
		#gnagna
	end
	
	def sauvelelu(fichier)
		fichier.puts "dans un fichier oh oh\n"
		fichier.puts "de Dana lalilala \n"
		fichier.puts "j'ai sauvé l'élu  \n"
	end
	
	def decrirepopulation(fichier)
		fichier.print("********************************\n")
		fichier.print("Ceci est la génération n° : " + String(self.niemegeneration) + "\n")
		Population.operateurs.afficherValeurs(fichier)
		Population.terminaux.afficherValeurs(fichier)
		fichier.print("Taille de la population : " + String(Population.taillepopu) + "\n")
		Population.afficherFonctionFitness(fichier)
		0.upto ((Population.taillepopu) -1) do |i|
			fichier.print("programme classé° " + String(i) + " \n")
			@tableaupopulation[i].ecrireFichierResultat(fichier)
			#fichier.print("programme id " + String(i) + " \n")
			#fichier.print(@tableaupopulation[i].donnerprogramme)
			#fichier.print("\n")
			#fichier.print("Il a trouvé " + String(@tableaupopulation[i].nbpatientsok) + " patients correctement pour " + String(@tableaupopulation[i].nbpatientstestes) + " \n")
			#fichier.puts("Son score est : " + String(@tableaupopulation[i].score))
			#fichier.print("\n")
		end
	end
	
	
	######################################################
	# THE fonction fitness                               #
	# Prend un ensemble de programmes                    #
	# de classe Programmme                               #
	# et un ensemble de patient                          #
	# Evalue avec les programmes chaque patient          #
	# Indique si vrai, faux positif ...                  #
	# Puis attribue un score de réussite aux programmes  #
	# Selon le calcul donné par fonctionscorefit         #
	# Penser à écrire dans un fichier log pour chaque    #
	# programme et pour chaque patient                   #
	######################################################
	
	def fitness(ensemblepatient)
	
	# variables locales
	t = Array.new
	
	
		###### On fait tourner tous les programmes sur tous les patients en multithreading #######
		###### On évalue le score obtenu grâce à la fonction fitness passée en paramètre dans le même temps #####
		t = Array.new
		0.upto ((Population.taillepopu) -1) do |i|
			t[i] = Thread.new {@tableaupopulation[i].EvaluerLesPatients(ensemblepatient)
				@tableaupopulation[i].calculerScore(Population.donnerFonctionFitness)
				}
		end
		
		0.upto ((Population.taillepopu) -1) do |j|
			t[j].join
		end
		
		###########################################################################################


	# on calcule le score du programme
	#	calculerScore(prog,fonctionscorefit)
	end
	
	#------- fin de la classe --------#

end
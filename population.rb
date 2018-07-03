require_relative "patient"
require_relative "programme"
require_relative "operateur"

class Population
	
	@@nbgene =0
	@@taillepopu = 0
	@@nbpatients = 0
	@@terminaux = [65,1]
	@@operateurs = nil
	
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
	
	def Population.ecrire_operateurs(operateurs)
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
	
	def premiereGeneration(profondeur)
		# je cree un programme aléatoirement
		# version = génération à laquelle le programme est créé
		# classement = par défaut le moins bon
		# prog = génération aléatoire avec les terminaux et les opérateurs
		# se pose la question arbre, s-expression, ou string toute faite
		# pour l'instant, string toute faite
		0.upto ((Population.taillepopu) -1) do |i|
			@tableaupopulation[i].generationSpontanee(1,profondeur,Population.operateurs,Population.terminaux)
			i += 1
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
	
	# comparer la décision du programme et celle clinique et classe
	# dans la classe Programme en vrai positif, faux négatifs ...
	def comparerResultatProgrammeClinique(resultatprog,resultatclinique,niemeprog)
	end
	
	def donnerIndividu(i)
		return @tableaupopulation[i]
	end
	
	def afficherGeneration
		puts @niemegeneration
	end
	
	def donnerGeneration
		return @niemegeneration
	end
	
	def inscritElu(fichier)
		fichier.print("prout\n")
	end
	
	def affichelelu
		#gnagna
	end
	
	def sauvelelu
		puts "dans un fichier oh oh\n"
		puts "de Dana lalilala \n"
		puts "j'ai sauvé l'élu  \n"
		puts " (en fait c'est elected.txt) \n"
	end
	
	def decrirepopulation(fichier)
		fichier.print("********************************\n")
		fichier.print("Ceci est la génération n° : " + String(donnerGeneration) + "\n")
		Population.operateurs.afficherValeurs(fichier)
		fichier.print("Nos terminaux : \n")
		fichier.print(Population.terminaux)
		fichier.print("\n")
		fichier.print("Taille de la population : " + String(Population.taillepopu) + "\n")
		fichier.print("Notre fonction fitness : \n")
		0.upto ((Population.taillepopu) -1) do |i|
			fichier.print("programme classé° " + String(i) + " \n")
			#fichier.print("programme id " + String(i) + " \n")
			fichier.print(@tableaupopulation[i].donnerprogramme)
			fichier.print("\n")
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
	
	def fitness(ensemblepatient,fonctionscorefit)
	
	# variables locales
		
	#prout = File.open("fitness.txt","a")	
	# on boucle en evaluant chaque patient par le programme
	# passé en paramètre
		
		0.upto ((Population.taillepopu) -1) do |i|
			#Insert Multithreading here
			individu = @tableaupopulation[i]
			Thread.new {
				individu.EvaluerLesPatients(ensemblepatient)
			}
			i+=1
			
		end

	# on calcule le score du programme
	#	calculerScore(prog,fonctionscorefit)
	end
	
	#------- fin de la classe --------#

end
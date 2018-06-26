require_relative "patient"
require_relative "programme"

class Population
	
	@@nbgene =0
	@@taillepopu = 0
	@@nbpatients = 0
	@@terminaux = [65,1]
	@@operateurs = ['+','-','<','>','*']
	
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
	
	attr_accessor :niemegeneration
	
	def initialize
		@niemegeneration = 1
		@tableaupopulation = Array.new(Population.taillepopu)
		
		# on crée l'ensemble prêt à recevoir chaque programme
		0.upto ((Population.taillepopu) -1) do |i|
			generationSpontanee(@niemegeneration,i + 1,i)
			i += 1
		end
	
	end
	
	def generationSpontanee(version,classement,placetableau)
		# je cree un programme aléatoirement
		# version = génération à laquelle le programme est créé
		# classement = par défaut le moins bon
		# prog = génération aléatoire avec les terminaux et les opérateurs
		# se pose la question arbre, s-expression, ou string toute faite
		# pour l'instant, string toute faite
		prog = "if (((self.age * 1.5 + 45) > self.pression) && not(self.existeHepatomegalie)) then 'true'  else 'false' end"
		@tableaupopulation[placetableau] = Programme.new(prog, version, classement)
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
		fichier.print("Nos opérateurs : \n")
		fichier.print(Population.operateurs)
		fichier.print("\n")
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
		
	prout = File.open("prout.txt","a")	
	# on boucle en evaluant chaque patient par le programme
	# passé en paramètre
		
		0.upto ((Population.taillepopu) -1) do |i|
			#Insert Multithreading here
			individu = @tableaupopulation[i]
			Thread.new {
				0.upto ((Population.nbpatients) -1) do |j|
					resultat = individu.evaluerMonPatient(ensemblepatient[j])
					prout.print("Le programme ")
					prout.print(individu)
					prout.print("a trouvé : ")
					prout.print(resultat)
					prout.print("pour le patient ")
					prout.print(j)
					prout.print("\n)")
					# ici comparer prono réel patient et resultat obtenu
					#puts "pour le patient" + String(j) + " le programme "
					j += 1	
				end
			}
			i+=1
			
		end

	# on calcule le score du programme
	#	calculerScore(prog,fonctionscorefit)
	end
	
	#------- fin de la classe --------#

end
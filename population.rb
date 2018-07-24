require_relative "programme"
require_relative "operateur"

class Population
	
	@@nbgene =0
	@@taillepopu = 0
	@@nbpatients = 0
	@@scoreelu =0
	@@terminaux = nil
	@@operateurs = nil
	@@foncfit =""
	@@mode = {"full" => 'f', "growth" => 'g', "ramped" => 'r', "tournament" => 't', "elite" => 'e'}
	
	def self.ecrire_nbgene
		@@nbgene = Integer(gets)
	end

	def self.ecrire_scoreelu
		@@scoreelu = Float(gets)
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
	
	def self.scoreelu
		@@scoreelu
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
	
	def genererPopulationTournoi(tailletournoi)
		nombretournoi = (tableaupopulation.size) / tailletournoi
		tableaupopulationresultat = Array.new((@tableaupopulation.size))
		tableautournoi = Array.new(nombretournoi)

		0.upto (nombretournoi -1) do |i|
			tableautournoi[i] = Array.new
			1.upto tailletournoi do |j]
				x = rand(0..((@tableaupopulation.size) -1))
				tableautournoi[i].push(@tableaupopulation[x])
				@tableaupopulation.delete_at(x)
			end
			tableautounoi[i].sort_by {|x| x.score)
			# je crossover les x% les meilleurs

			# je garde la majorité

			#ne sont pas retenus les y correspondants à y générés par crossmatch
		end

		# Je mute ceux qui n'ont pas été sélectionnés dans un tournoi

	end

	# génère une population une nieme population avec n>1
	# A n>1, on génère en fonction de règles bien précises (tournoi, sélection, random)
	def genererPopulation(niemegeneration,mode)
		case mode
		when 't'	#mode tournoi#
			genererPopulationTournoi
		when 'e' #mode elite#
			0.upto ((Population.taillepopu) -1) do |i|
				@tableaupopulation[i].generationSpontaneeGrowth(1,profondeur,Population.operateurs,Population.terminaux)
				i += 1
			end
		else # random
			0.upto ((Population.taillepopu) -1) do |i|
				@tableaupopulation[i].generationSpontaneeRamped(1,profondeur,Population.operateurs,Population.terminaux,i)
				i += 1
			end
		end	

	end
	
	
	def donnerIndividu(i)
		return @tableaupopulation[i]
	end
	
	def afficherGeneration(fichier)
		fichier.puts(@niemegeneration)
	end
	
	def inscritElu(fichier)
		fichier.puts("------------------------------------")
		fichier.puts("-----No more generations after------")
		fichier.puts("-----'Cause we got the one----------")
		@tableaupopulation[0].ecrireFichierResultat(fichier)
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
	
	def fitness(ensemblepatient,log)
	
		# variables locales
	
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
		
	
	######################   On range le tableau en fonction du score   ################################
		@tableaupopulation.sort_by! {|x| x.score} #les meilleurs sont à la fin du tableau
		decrirepopulation(log)
	########### Si on a trouvé l'élu ou si le nombre maximum de générations ont été atteintes###########

		if ((@tableaupopulation[0].score) >= (Population.scoreelu)) or (niemegeneration >= (Population.nbgene))
			if @tableaupopulation[0].score >= (Population.scoreelu)
				inscritElu(log)
				sauvelelu(STDOUT)
				# ici glisser le code pour créer un fichier avec l'élu qui permettra de le charger 
				# et de le faire tourner sur un set de patients
				#modifier la fonction sauvelelu
				return 0
			else
				log.puts("echec, nous sommes arrivés au bout des générations")
				return 0
			end
		else
			1
		end
			
	end
	
	#------- fin de la classe --------#

end
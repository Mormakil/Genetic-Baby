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
			@@foncfit = fit.gets
		rescue
			puts "fitness.txt ne s'est pas ouvert"
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
	attr_reader :profondeur

	def initialize(numerogeneration,profondeur)
		@niemegeneration = numerogeneration
		@tableaupopulation = Array.new(Population.taillepopu)
		@profondeur = profondeur
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
	
	def premiereGeneration(mode)
		case mode
		when 'f'	
			0.upto ((Population.taillepopu) -1) do |i|
				@tableaupopulation[i].generationSpontaneeFull(1,@profondeur,Population.operateurs,Population.terminaux)
				i += 1
			end
		when 'g'
			0.upto ((Population.taillepopu) -1) do |i|
				@tableaupopulation[i].generationSpontaneeGrowth(1,@profondeur,Population.operateurs,Population.terminaux)
				i += 1
			end
		else
			0.upto ((Population.taillepopu) -1) do |i|
				@tableaupopulation[i].generationSpontaneeRamped(1,@profondeur,Population.operateurs,Population.terminaux,i)
				i += 1
			end
		end
	end

	def fullMutation
	0.upto ((@tableaupopulation.size) -1) do |i|
			copieprog = @tableaupopulation[i]
			@tableaupopulation[i] = copieprog.mutation(@profondeur,Population.operateurs,Population.terminaux)
		end
	end
	
	def genererPopulationTournoi(tailletournoi,nbpairescrossover)
		# taille tournoi doit être pair
		# pourcentage est un flottant entre 0 et 1
		if (tailletournoi%2) == 1
			puts("Nous agrandissons de 1 la taille du tournoi")
			tailletournoi += 1
		else
			puts("Taille du tournoi :" + String(tailletournoi))
		end

		nombretournoi = (@tableaupopulation.size) / tailletournoi
		tableaupopulationresultat = Array.new
		tableautournoi = Array.new(nombretournoi)

		0.upto ((nombretournoi) -1) do |i|
			# pour chaque tournoi je créée un tableau de taille tournoi ...
			tableautournoi[i] = Array.new
		

			0.upto (tailletournoi - 1) do |j|
				x = rand(0..((@tableaupopulation.size) -1))
				# ... et je met dans le tournoi un élément au hasard qui viendra se battre avec d'autres
				tableautournoi[i].push(@tableaupopulation[x].copie)
				@tableaupopulation.delete_at(x) #à la fin de la boucle, tableaupopulation ne contient que les outcasts qui seront mutés
			end

			# A chaque tableau de tournoi, je les classe par score (plus haut score à la fin pour rappel)
			tableautournoi[i].sort_by {|x| x.score}
			# je calcule le nombre de crossover que je fais : c'est un nombre de paires !!!!! donc x paires = x paire d'offsprings
			nbcrossover = nbpairescrossover *2
			nboffsprings = nbpairescrossover * 2
			# qui donneront 2 crossoveré pour 2 offsprijngé 
			# ceux auquels on ne touchera pas : ceux qui restent en plus des élites du crossover et ceux issus du crossover
			nbgardes = tailletournoi - nboffsprings - nbcrossover

			#ne sont pas retenus les y correspondants aux y offsprings
			0.upto((nboffsprings) -1) do |j|
				tableautournoi[i].delete_at(0)
			end

            # je garde la majorité
			0.upto((nbgardes) -1) do |j|
				tableaupopulationresultat.push(tableautournoi[i][0].copie)
				tableautournoi[i].delete_at(0)
			end

			# je crossover les x% les meilleurs
			j = 0
			while (j < ((tableautournoi[i].size) -1)) do
				p1 = tableautournoi[i][j].copie
				j+=1
				p2 = tableautournoi[i][j].copie
				tableaupopulationresultat.push(p1)
				tableaupopulationresultat.push(p2)
				tprog = p1.crossmatch(p2)
				tableaupopulationresultat.push(tprog[0])
				tableaupopulationresultat.push(tprog[1])
				j+=1
			end	
		end
		
		puts("Taille du tableau de resultat : " + String(tableaupopulationresultat.size))
		# Je mute ceux qui n'ont pas été sélectionnés dans un tournoi
		0.upto ((@tableaupopulation.size) -1) do |i|
			@tableaupopulation[i].mutation(@profondeur,Population.operateurs,Population.terminaux)
		end

		0.upto ((tableaupopulationresultat.size) - 1) do |i|
			@tableaupopulation.push(tableaupopulationresultat[i].copie)
		end

	end

	# génère une population une nieme population avec n>1
	# A n>1, on génère en fonction de règles bien précises (tournoi, sélection, random)
	def genererPopulation(mode)
		case mode
		when 't'	#mode tournoi#
			genererPopulationTournoi(20,4)
		when 'e' #mode elite#
			puts("modeelite")
		when 'p'
			puts("mode test avec premiereGeneration")
			premiereGeneration('f')
		when 'm'
			puts("mode full mutation")
			fullMutation
		else # random
			puts("random")
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
	
	def sauveLElu(fichier)
		fichier.puts "dans un fichier oh oh\n"
		fichier.puts "de Dana lalilala \n"
		fichier.puts "j'ai sauvé l'élu  \n"
	end
	
	def decrirePopulation(fichier)
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
		dernierelt = (Population.taillepopu) -1
	
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
		@tableaupopulation.sort_by! {|x| x.score} #les scores les plus élevés sont à la fin du tableau => donc penser à ramener sur 1 et faire 1- score si on veut une valeur de score basse
		decrirePopulation(log)
	########### Si on a trouvé l'élu ou si le nombre maximum de générations ont été atteintes###########

		if (((@tableaupopulation[dernierelt].score) >= (Population.scoreelu)) or (self.niemegeneration > (Population.nbgene)))
			if (@tableaupopulation[dernierelt].score >= (Population.scoreelu))
				inscritElu(log)
				sauveLElu(STDOUT)
				# ici glisser le code pour créer un fichier avec l'élu qui permettra de le charger 
				# et de le faire tourner sur un set de patients
				#modifier la fonction sauvelelu
				return 0
			else
				log.puts("echec, nous sommes arrivés au bout des générations")
				return 0
			end
		else

			log.puts("why do we fall ?")
			return 1
		end
			
	end
	
	#------- fin de la classe --------#

end
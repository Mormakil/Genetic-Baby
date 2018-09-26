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

	def self.ecrireTaillePopu(nouvelletaille)
		@@taillepopu = nouvelletaille
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
				@tableaupopulation[i].generationSpontaneeFull(@profondeur,Population.operateurs,Population.terminaux)
				i += 1
			end
		when 'g'
			0.upto ((Population.taillepopu) -1) do |i|
				@tableaupopulation[i].generationSpontaneeGrowth(@profondeur,Population.operateurs,Population.terminaux)
				i += 1
			end
		else
			0.upto ((Population.taillepopu) -1) do |i|
				@tableaupopulation[i].generationSpontaneeRamped(@profondeur,Population.operateurs,Population.terminaux,i)
				i += 1
			end
		end
	end

	# Attention, ici sémaantiquement faux ; il n'y a pas de recopie de la structure. Il y a copie d'adresse
	# L'arbre originel est donc modifié.
	def fullMutation
	0.upto ((@tableaupopulation.size) -1) do |i|
			copieprog = @tableaupopulation[i]
			@tableaupopulation[i] = copieprog.mutation(@profondeur,Population.operateurs,Population.terminaux)
		end
	end
	
	def subCrossmatch(t1,t2)
		puts(t1.size)
		j = 0
		while (j < ((t1.size) -1)) do
			p1 = t1[j].copie
			j+=1
			p2 = t1[j].copie
			t2.push(p1)
			t2.push(p2)
			tprog = p1.crossmatch(p2)
			t2.push(tprog[0])
			t2.push(tprog[1])
			j+=1
		end	
	end

def genererPopulationTournoi(tailletournoi,pourcentagecrossmatch,pourcentagemutation,pourcentagecopie)
		# Le nombre de tournoi décide de la taille du tournoi
		# Sécurité : le dernier tournoi risque d'être plus petit que les autres
		# Dans l'idéal demander une taille de tournoi avec reste 0 (que des tournois pleins)

		nombretournoi = (@tableaupopulation.size) / tailletournoi
		tailletournoirestant = (@tableaupopulation.size) % tailletournoi
		tableaupopulationresultat = Array.new

		if (tailletournoirestant > 0)
			nombretournoi +=1
		end

		if (nombretournoi < 2)
			@tableaupopulation.sort_by {|x| x.score}
			index1 = (@tableaupopulation.size) -1
			index2 = (@tableaupopulation.size) -2
			t = [@tableaupopulation[index1],@tableaupopulation[index2]]
			subCrossmatch(t,tableaupopulationresultat)
		else
			# le tableau des survivants
			tableauhighlander = Array.new
			tableautournoi = Array.new(tailletournoi)
			puts("Nombre de tournois :" + String(nombretournoi))

			while (@tableaupopulation.size > tailletournoirestant) do
		
				0.upto (tailletournoi - 1) do |j|
					x = rand(0..((@tableaupopulation.size) -1))
					# ... et je met dans le tournoi un élément au hasard qui viendra se battre avec d'autres
					tableautournoi[j] = @tableaupopulation[x].copie
					@tableaupopulation.delete_at(x) 
				end

				# A chaque tableau de tournoi, je les classe par score (plus haut score à la fin pour rappel)
				#tableautournoi.sort_by {|x| x.score}
				tableautournoi = tableautournoi.sort do |a,b|
					a.score <=> b.score
				end

				puts("scores du tournoi classé du plus petit au plus grand")

				0.upto (tailletournoi - 1) do |j|
					
					puts(tableautournoi[j].score)
					 
				end

				# Et je le met dans le tableau des sélectionnés : le fameux tableau highlander
				tableauhighlander.push(tableautournoi[tailletournoi -1])
			end
			# On s'occupe en dernier de ceux en trop
			if (tailletournoirestant > 0)
				@tableaupopulation.sort_by {|x| x.score}
				# En mettant le meilleur dans le tableau des sélectionnés
				tableauhighlander.push(@tableaupopulation[tailletournoirestant -1])
			end
			# On a tout nos sélectionnés : 
			# Je répartie selon le pourcentage - pour rappel, ils sont déjà répartis au hasard. 
			nbmutations = ((tableauhighlander.size)*pourcentagemutation)/100
			nbcopies = ((tableauhighlander.size)*pourcentagecopie)/100
			nbcrossmatch = (tableauhighlander.size) - nbmutations - nbcopies
			# Je m'assure de n'avoir que des paires pour le crossmatch
			if ((nbcrossmatch%2) != 0)
				nbcopies += 1
				nbcrossmatch -=1
			end
			# je fais les mutations
			0.upto((nbmutations) -1) do |j|
				p1 = tableauhighlander[0].copie
				tableauhighlander.delete_at(0)
				p1.mutation(@profondeur,Population.operateurs,Population.terminaux)
				tableaupopulationresultat.push(p1)
			end
			# je fais les copies
			0.upto((nbcopies) -1) do |j|
				tableaupopulationresultat.push(tableauhighlander[0].copie)
				tableauhighlander.delete_at(0)
			end
			# je fais les cross-over : sachant qu'il n'y a que des paires, i va aller de 0 à nb crossover / 2
			subCrossmatch(tableauhighlander,tableaupopulationresultat)
			#à partir de là, il peut y avoir, selon la taille du tournoi , la population diminue de taille
			#penser à bien diminuer le nombre runs puisque la population deviendra trop petite., se recopiera et mutera uniquement.
			#bien que s'il n'en reste que deux, on pourrait systématiquement les croiser entre eux
		end
		
		@tableaupopulation = []
		# je recopie la population
		0.upto ((tableaupopulationresultat.size) - 1) do |i|
			@tableaupopulation.push(tableaupopulationresultat[i].copie)
		end

		Population.ecrireTaillePopu(@tableaupopulation.size)

	end

	# génère une population une nieme population avec n>1
	# A n>1, on génère en fonction de règles bien précises (tournoi, sélection, random)
	def genererPopulation(mode)
		case mode
		when 't'	#mode tournoi# : taille tournoi, pourcentage crossmatch, pourcentage mutation, pourcentage copie
			genererPopulationTournoi(4,80,10,10)
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
		n = (@tableaupopulation.size) -1 #on prend le dernier : le meilleur
		@tableaupopulation[n].ecrireFichierResultat(fichier)
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
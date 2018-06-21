require_relative "patient"
require_relative "programme"

class Population 


def initialize(nbpatient,taillepopulation, ensembleterminaux, ensembleoperateurs,nbmaxgenerations)
	@nbpatient = nbpatient
	@nbmaxgenerations = nbmaxgenerations
	@taillepopulation = taillepopulation
	@ensembleterminaux = ensembleterminaux
	@ensembleoperateurs = ensembleoperateurs
	@niemegeneration = 1
	@tableaupopulation = Array.new(taillepopulation)
	
	# on crée l'ensemble prêt à recevoir chaque programme
	0.upto (taillepopulation -1) do |i|
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
	prog = "if (((@age * 1.5 + 45) > @pression) && not(@hepatomegalie)) then 'true'  else 'false' end"
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

def donnerTaillePopulation
	return @taillepopulation
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
	fichier.print(@mesoperateurs)
	fichier.print("\n")
	fichier.print("Nos terminaux : \n")
	fichier.print(@mesterminaux)
	fichier.print("\n")
	fichier.print("Taille de la population : " + String(donnerTaillePopulation) + "\n")
	fichier.print("Notre fonction fitness : \n")
	0.upto (@taillepopulation -1) do |i|
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
	
	
# on boucle en evaluant chaque patient par le programme
# passé en paramètre
	0.upto ((donnerTaillePopulation) -1) do |i|
		#monindividu = donnerIndividu(i) #ici donner l'adresse pour pouvoir effectuer les modifs
		0.upto (@nbpatient -1) do |j|
			resultat = @tableaupopulation[i].evaluerMonPatient(ensemblepatient[j])
			# ici comparer prono réel patient et resultat obtenu
			puts "pour le patient" + String(j) + " le programme "
			@tableaupopulation[i].afficherId 
			puts " a trouvé : "
			puts resultat
			puts "\n"
			j += 1	
		end
	
		i+=1	
	end

# on calcule le score du programme
#	calculerScore(prog,fonctionscorefit)
end

#------- fin de la classe --------#

end
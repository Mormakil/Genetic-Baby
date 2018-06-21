require_relative "patient"
require_relative "programme"

class Population 


def initialize(nbpatient,taillepopulation, ensembleterminaux, ensembleoperateurs)
	@nbpatient = nbpatient
	@taillepopulation = taillepopulation
	@ensembleterminaux = ensembleterminaux
	@ensembleoperateurs = ensembleoperateurs
	@niemegeneration = 0
	@tableaupopulation = Array.new(taillepopulation) { |i|  }
	
	# on crée l'ensemble prêt à recevoir chaque programme
	0.upto (taillepopulation -1) do |i|
		generationSpontanee(0,0,i)
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
# A n0, la population est générée aléatoirement
# A n>0, on génère en fonction de règles bien précises (tournoi, sélection, random)
def genererPopulation(niemegeneration,taillepopulation,population)
end

# comparer la décision du programme et celle clinique et classe
# dans la classe Programme en vrai positif, faux négatifs ...
def comparerResultatProgrammeClinique(resultatprog,resultatclinique,prog)
end

def affichergeneration
	puts @niemegeneration
end

def donnergeneration
	return @niemegeneration
end

def donnertaillepopulation
	return @taillepopulation
end

def decrirepopulation(fichier)
	fichier.print("********************************\n")
	fichier.print("Ceci est la génération n° : " + String(donnergeneration) + "\n")
	fichier.print("Nos opérateurs : \n")
	fichier.print(@mesoperateurs)
	fichier.print("\n")
	fichier.print("Nos terminaux : \n")
	fichier.print(@mesterminaux)
	fichier.print("\n")
	fichier.print("Taille de la population : " + String(donnertaillepopulation) + "\n")
	fichier.print("Notre fonction fitness : \n")
	0.upto (@taillepopulation -1) do |i|
		fichier.print("programme n° " + String(i) + " \n")
		fichier.print(@tableaupopulation[i].donnerprogramme)
		fichier.print("\n")
	end
end

=begin

def calculerScore(prog,fit)
	b = prog.get_binding
	prog.ecrirescore(eval(fit,b)) 
end

######################################################
# THE fonction fitness                               #
# Prend un prog de classe Programmme                 #
# et un ensemble de patient                          #
# Evalue avec le programme chaque patient            #
# Indique si vrai, faux positif ...                  #
# Puis attribue un score de réussite au programme    #
# Selon le calcul donné par fonctionscorefit         #
# Penser à écrire dans un fichier log pour chaque    #
# programme et pour chaque patient                   #
######################################################

def fitness(prog,ensemblepatient,fonctionscorefit,cheminfichierlog)

# variables locales
	nombrepatient = sizeof(ensemblepatient)
	log = File.open("cheminfichierlog", "w+")
	

# on boucle en evaluant chaque patient par le programme
# passé en paramètre
	0.upto nombrepatient do |i| {
		patientactuel = ensemblepatient[i].get_binding
		resultat = eval(prog,patientactuel)
		comparerResultatProgrammeClinique(resultat,ensemblepatient[i].@resultat,prog)
	}

# on calcule le score du programme
	calculerScore(prog,fonctionscorefit)
end

=end

end
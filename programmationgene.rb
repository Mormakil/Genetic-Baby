require_relative "patient"
require_relative "programmme"

def generationSpontanee(ensembleterminaux,ensembleoperateurs)
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

def fitness(prog,ensemblepatient)

# variables locales
nombrepatient = sizeof(ensemblepatient)

# on boucle en evaluant chaque patient par le programme
# passé en paramètre

0.upto nombrepatient do |i| {
	patientactuel = ensemblepatient[i].get_binding
	resultat = eval(prog,patientactuel)
	comparerResultatProgrammeClinique(resultat,ensemblepatient[i].@resultat,prog)
}

end

################ Ici débute le "main" ###############
# On lance l'algo pour obtenir l'alfa programme   ###
# Après "darwinisme"                              ###
#####################################################


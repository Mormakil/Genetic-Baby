require_relative "patient"

class Programme

def initialize(prog,version,classement)
	@prog = prog
	@nbpatientstestes = 0
	@nbpatientsok = 0
	@tauxpatientsok = 0.0
	@nbfauxnegatifs = 0
	@score = 0.0
	@idprogramme = [version,classement]
end

def donnerprogramme
	return @prog
end

def afficherprogramme
	puts @prog
end

def afficherId
	puts @idprogramme[0]
	puts @idprogramme[1]
end

def ecrireScore(score)
	@score = score
end

def ecrirenbPatientTestes(nbpatient)
	@nbpatientstestes = nbpatient
end

def increasePatientTestes
	@nbpatientstestes += 1
end

def increasePatientOk
	@nbpatientsok += 1
end

def calculetauxPatientOk
#	@tauxpatientsok = (@nbpatientsok / @nbpatientstestes)
end

def ecrireFichierResultat(fichier)
	fichier.print("******************************")
	fichier.print("Resultat du programme : " + @idprogramme)
	fichier.print("Fonction : " + @prog)
	fichier.print("Score donné par la fonction fitness: " + @score)
end

def evaluerMonPatient(monpatient)
	b = monpatient.get_binding
	resultat = eval(@prog,b)
	return resultat
end

end
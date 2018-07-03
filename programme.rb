require_relative "patient"
require_relative "tree"

class Programme
	
	attr_reader :idprogramme
	
	def initialize(arbre,version,classement)
		@arbre = arbre
		@nbpatientstestes = 0
		@nbpatientsok = 0
		@tauxpatientsok = 0.0
		@nbfauxnegatifs = 0
		@score = 0.0
		@idprogramme = [version,classement]
	end
	
	def generationSpontanee(mode,profondeur,operateurs,terminaux)
		@arbre = Tree.new(nil)
		Tree.genererArbreIncomplet(profondeur,operateurs,terminaux,@arbre)
	end
	
	def donnerprogramme
		return @arbre.parser
	end
	
	def afficherprogramme
		puts @arbre.parse
	end
	
	def donnererIdClassement
		@idprogramme[1]
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
	
	def evaluerMonPatient(monpatient,monprog)
		#mon prog est une chaine de caractère issue de Tree.parser
		# ceci évite de refaire le parsing de l'arbre pour chaque évaluation de patient
		b = monpatient.get_binding
		resultat = eval(monprog,b)
		return resultat
	end
	
	def EvaluerLesPatients(tabpatient)
		n = (tabpatient.size) - 1
		s = @arbre.parser
		puts(s)
		f = File.open("prout.txt","a")
		0.upto n do |i|
			resultat = evaluerMonPatient(tabpatient[i],s)
			print("Le programme ")
			print(i)
			#print(self.idprogramme[1])
			print("a trouvé : ")
			print(resultat)
			print("pour le patient ")
			#print(tabpatient[i].id)
			print("\n)")
					# ici comparer prono réel patient et resultat obtenu
					#puts "pour le patient" + String(j) + " le programme "
			i += 1	
		end
	end

end
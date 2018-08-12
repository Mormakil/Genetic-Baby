require "csv"


#### La minimaliste classe patient ######
class Patient

	
	####### 1 : les attributs, pour lire les données du patient #######
	######## On ne modifie pas le données d'un patient          #######
	attr_reader :id
	attr_reader :resultat
	
	def initialize (id,result)
		@id = id
		@resultat = result
	end
	
	def get_binding
		return binding()	
	end



	####### 2 : méthode de classe pour lire un CSV #######
	############### Prend un chemin en paramètre   #######
	#### et renvoie un tableau de patients         #######
	
	def Patient.lireCsv(chemin)
		
		tabpatient = Array.new
		begin
			puts "Chargement des patients \n"	
			
			CSV.foreach(chemin,{ encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
				monhash = row.to_hash # il est bon, mon hash
				tabpatient.push(Patient.new(monhash[:id],monhash[:resultat]))
			end
			
			puts(chemin)
			puts ".csv opened successfully \n"
			puts "array loaded \n"
		rescue
			print(chemin)
			puts " not found\n"
			puts "we create random patients \n"
			tabpatient = Array.new(100)
			0.upto 99 do |i|
				tabpatient[i] = Patient.new(i,1)
				i += 1
			end
		end
		return tabpatient
	end

end

########## Une sous-classe visant à évaluer le remplissage chez des patients ###########

class Pressionpatient < Patient

	
	####### 1 : les attributs, pour lire les données du patient #######
	######## On ne modifie pas le données d'un patient          #######
	attr_reader :age
	attr_reader :pression
	attr_reader :hepatomegalie
	attr_reader :pressionmin
	
	def initialize (id,age,pression,hepatomegalie,result)
		super
		@age = age
		@pression = pression
		@hepatomegalie = hepatomegalie
		@pressionmin = 45 + pression * 1.5
	end
	
	def existeHepatomegalie
		return (@hepatomegalie == 1)
	end
	
	
	####### 2 : méthode de classe pour lire un CSV #######
	############### Prend un chemin en paramètre   #######
	#### et renvoie un tableau de patients         #######
	
	def agerandom
		rand(14..20)
	end

	def pressionrandom
		rand(50..110)
	end

	def hepatorandom
		rand(0..1)
	end
	
	def Pressionpatient.lireCsv(chemin)
		begin
			puts "on y est \n"
			tabpatient = Array.new
			CSV.foreach(chemin,{ encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
				
				monhash = row.to_hash # il est bon, mon hash
				tabpatient.push(Pressionpatient.new(monhash[:id],monhash[:age],monhash[:pression],monhash[:hepatomegalie],monhash[:resultat]))
				puts(monhash[:age])
			end
			if tabpatient[0] != nil
				puts chemin + " opened successfully"
				puts "array loaded \n"
			end
		rescue
			puts "patients.csv not found\n"
			puts "we create random patients \n"
			tabpatient = Array.new(100)
			0.upto 99 do |i|
				tabpatient[i] = Pressionpatient.new(i,agerandom,pressionrandom,hepatorandom,'true')
				i += 1
			end
		end
		return tabpatient
	end
################ Fin de Classe ##################@
end





#####################Fin de fichier###############@
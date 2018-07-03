# Encore et toujours du Ruby

require "csv"

################################################################
## Pour les opérateurs, savoir à combien de terminaux         ##
## ils s'appliquent. Eg : * nécessairement 2, + 1 ou 2, not 1 ##
################################################################

###### Penser à un nombre binaire allant de 0 à 7 ##############
#  1 terminal = 001  => 1                                      #
#  2 terminaux = 010 => 2                                      #
#  1 ou 2 terminaux = 011 => 3                                 #
#  3 terminaux = 100 => 4                                      #
################################################################

class Operateur

     attr_reader :valeur
     attr_reader :combien
     
     def initialize(valeur,combien)
          @valeur = valeur
          @combien = combien
     end

######### Fin de classe ################@@     
end
          
          
class Operateurs
     
     attr_reader :tableau
     
     # Prend en paramèter le chemin vers un csv contenant les opérateurs #
     def initialize(chemin)
          @tableau = Array.new
          begin
            puts "Chargement des opérateurs \n"
            
            CSV.foreach(chemin,{ encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
               monhash = row.to_hash # il est bon, mon hash
               @tableau.push(Operateur.new(monhash[:valeur],monhash[:combien]))
            end
            puts(chemin)
            puts ".csv opened successfully \n"
            puts "array loaded \n"
          
          rescue
            puts(chemin)
            puts ".csv not opened\n"
            puts "we give standart operators \n"
            @tableau[0] = Operateur.new('+',3)
            @tableau[1] = Operateur.new('-',3)
            @tableau[2] = Operateur.new('*',2)
            @tableau[3] = Operateur.new('/',2)
          end
     end
     
     def afficherValeurs(fichier)
          fichier.puts(" Les opérateurs sont : ")
          0.upto ((@tableau.size) - 1) do |i|
               fichier.print(@tableau[i].valeur + " ")
          end
          fichier.print("\n")
     end

######### Fin de classe ################@@     
end

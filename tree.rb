class Tree
     
     attr_reader :valeur
     
     def initialize(valeur)
          @valeur = valeur  #il n'y a pas d'évaluation stricto sensu de l'arbre. On construit des  chaines de caractères qu'on évalue ensuite
          @fils = nil
     end
     
     def estFeuille?
          @fils == nil
     end
     
     def estRacine?
          @fils != nil
     end
     
     def ajouterFils(valeur)
          f = Tree.new(valeur)
          if (@fils == nil)
               @fils = Array.new
               @fils.push(f)
          else
               @fils.push(f)
          end
     end
     
     def nombreFils
          if self.estRacine?
               @fils.size
          else
               0
          end
     end
     
     def parser
          n = self.nombreFils
          case n
          when 0 #on est sur une feuille
               self.valeur
          when 1 #cas de la négativisation de valeur
               @fils[0].parser + self.valeur
          when 2 #comparaison, opérations arithmétiques ... il faut blinder avec les parenthèses
               "(" + @fils[0].parser + self.valeur + @fils[1].parser + ")"
          when 3 #cas du if then else principalement (à écrire)
          "You passed a string"
          else
          "You gave me #{x} -- I have no idea what to do with that."
          end
     end
  # ---------- Fin de classe ----------#   
end

monarbre = Tree.new("+")
puts(monarbre.estFeuille?)
monarbre.ajouterFils("3")
monarbre.ajouterFils("4")
s = monarbre.parser
print(s)
puts "\n"
puts(eval(s))
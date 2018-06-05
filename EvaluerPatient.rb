#!/usr/bin/env ruby

printf("Bonjour beau gosse\n");
printf("Indique moi la fonction d'évaluation\n");

#adresse = gets()
#print(adresse)
fichiercommande = File.open("fonction.txt")
commande = fichiercommande.gets()
print(commande)
eval(commande)



#/usr/bin/perl

# --------BAO1 Version: Perl-RegEx----------------
# Le programme prend en entrée :
# 1. le nom du répertoire contenant les fichiers xml à traiter
# 2. le code imbriqué dans le nom du fichier servant à préciser quelle rubrique prise en compte (à la une correspond au code 3208 par ex.)
# Le programme extrait le texte dans des balises <title> et <description> et construit en sortie :
# 1. un fichier texte brut 
# 2. un fichier xml structuré
# Ce script est lancé de la manière suivante
# perl BAO1.pl repertoire_corpus(./2019) rubrique(3208)
# ---------------------------------------

################################ programme principal
# instruction qui oblige le scripteur a ecrire le script le plus correct possible
use strict;
# l'affichage sur teminal doit etre en utf8
binmode(STDOUT,":utf-8");
# creer une liste @argv 
# perl toto.pl xxx.xml, argv
# argv[0] est le nom du fichier : une chaine de caracteres
# my dans une boucle est suivi d'une variable locale, en dehors, suivi d'une variable globale
# il faut utiliser my partout quand on a cette instruction use strict
# my ici indique que ces variables sont 
my $fichier=$ARGV[0];
my $texteLu="";
open(FIC,"<:encoding(UTF8)",$fichier);
open(OUT,">:encoding(UTF8)","sortie.txt");
open(OUTXML,">:encoding(UTF8)","sortie.xml");
print OUTXML "<?xml version=\'1.0\' encoding=\"utf-8\" ?>\n";
print OUTXML "<sortie>\n";
# c'est pas ligne par ligne qu'on travaille, la expression reguliere cherche dans plusieurs lignes
# strategie 1 : supprimer les retours a la ligne
# strategie 2 : traiter tout le fichier comme un string (prendra bcp de memoires)
## Etape 1 : concatener toutes les lignes du fichier en une seule chaine
####### strategie 2##############
# lecture du fichier
$/=undef; #equivalent a $\=""
my $textelu=<FIC>; # remplace la boucle while 
my $textelu=~s/\r?\n//g;
# my ici n'existe que dans la boucle
####### strategie 1##############
# while(my $ligne=<FIC>) {
#   # 1.chomp supprimer les \n
#   chomp $ligne;
#   # 2.~s/x/y/; substituer x par y
#   $ligne=~s/\r//;
#   # 1.2.peut altertivement effectue comme ca, [xy]x ou y ou les deux
#   # $ligne=~s/[\r\n]//; 
#   # concatenation "."
#   $texteLu=$texteLu." ".$ligne;
# }
## Etape 2 : extraire ce qui nous interesse
# ~/ce qu'on recherche/, l'operation de recherche trouve la premiere occurrence mais on a besoin de toutes les occurrences. on va donc utiliser while avec l'option g (qui permet d'enchainer le processus de recherche au lieu d'arreter des qu'on trouve la premiere correspondance) au lieu de if
while ($texteLu=~/<item>.*?<title>(.+?)<\/title>.+?<description>(.+?)<\/description>/sg) {
  # memorisation des variables $1 pour la premiere parenthese, etc
  my $titre=$1;
  my $description=$2;
  ## nettoyage & qui signifie que ceci fair reference a un sous-programme
  # supprimer les bruits ht='1' src='http://rss.lemonde.fr/c/205/f/3050/s/4c93b4eb/sc/3/mf.gif' border='0'/&gt ...
  # () est une liste en perl, cette liste reste ici et sert qu'a l'affectation
  # my $titre_nettoye=&nettoyage($titre);
  ($titre,$description)=&nettoyage($titre,$description);
  # sortie txt
  print OUT "TITRE : ", $titre, "\n";
  print OUT "DESCRIPTION :", $description, "\n";
  # print "DESCRIPTION :", $description, "\n";
  print OUT "------------\n";
  # grammire d'un document xml
  # sortie -> item+
  # item -> titre, description
  # titre -> texte
  # description -> texte
  print OUTXML "<item>\n";
  print OUTXML "<titre>$titre</titre>\n";
  print OUTXML "<description>$description</desciption>\n";
  print OUTXML "</item>\n";
}
print OUTXML "</item>\n";
close(FIC);
close(OUT);
# scalar

##################### sous-programmes (sub)
sub nettoyage {
  # @_ liste recu, pour acceder a des liste, on utilise $
  # on veut que les variables soit utilisees ici, my est obligatoire
  # shift/shift(@_) : on prend le premier element d'une liste et on le renvoie
  my $titre=shift(@_);
  my $description=shift(@_);
  my $titre=$_[0];
  my $description=$_[1];
  # foreach my $element(@_){

  # }
  $description=~s/&lt;.+?&gt;//g;
  $titre=~s/&lt;.+?&gt;//g;
  $description=~s/&#38;&#34;/"/g;
  $titre=~s/&#38;&#34;/"/g;
  $description=~s/&#38;&#39;/'/g;
  $titre=~s/&#38;&#39;/'/g;
  # $ sert a reconnaitre la fin de chaine
  $titre=~s/$/\./g;
  return $titre,$description;
}

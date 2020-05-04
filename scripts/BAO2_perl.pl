#/usr/bin/perl

# --------BAO2----------------
# Le programme prend en entrée :
# 1. le nom du répertoire contenant les fichiers xml à traiter
# 2. le code imbriqué dans le nom du fichier servant à préciser quelle rubrique prise en compte (à la une correspond au code 3208 par ex.)
# Le programme extrait le texte dans des balises <title> et <description> et construit en sortie :
# 1. Un fichier structuré qui contient l'étiquetage de chaque phrase par TreeTagger. 
# 2. Un fichier TXT qui contient l'étiquetage fait par Talismane.
# Ce script est lancé de la manière suivante
# perl BAO2.perl repertoire_corpus(./2019) rubrique(3208)
# ATTENTION AU CHEMIN DE TREETAGGER ET DE TALISMANE
#-----------------------------------------------------------

my $rep="$ARGV[0]"; # 1er argument repertoire
my $rubrique="$ARGV[1]"; # 2eme argument rubrique
open(OUT,">:encoding(UTF8)","sortie_0105_$rubrique.txt");
open(OUTXML,">:encoding(UTF8)","sortietree_0105_$rubrique.xml");
open(OUTTALISMANE,">:encoding(UTF8)","sortieTalis_0105_$rubrique.txt");

print OUTXML "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n";
print OUTXML "<sortieCorpus>\n";
my %dico;
# on s'assure que le nom du répertoire ne se termine pas par un "/"
$rep=~ s/[\/]$//;
# # on initialise une variable contenant le flux de sortie 
# my $DUMPFULL1="";
# #----------------------------------------
# my $output1="SORTIE.xml";
# if (!open (FILEOUT,">$output1")) { die "Pb a l'ouverture du fichier $output1"};
# #----------------------------------------
&parcoursarborescencefichiers($rep);	#recurse!
#----------------------------------------
close OUT;
print OUTXML "</sortieCorpus>\n";
close OUTXML;
close OUTTALISME;
exit;
#----------------------------------------------
sub parcoursarborescencefichiers {
    my $path = shift(@_);
    opendir(DIR, $path) or die "can't open $path: $!\n";
    my @files = readdir(DIR);
    closedir(DIR);
    foreach my $file (@files) {
      # supprimer les repertoires caches . et ..
	    next if $file =~ /^\.\.?$/;
	    $file = $path."/".$file;
	    if (-d $file) { # -d permet de verifier si c'est un repertoire
      # si c'est un repertoire, je relance le programme
	    &parcoursarborescencefichiers($file);	#recurse!
	    }
	    if (-f $file) { # -f permet de verifier si c'est un fichier
#       TRAITEMENT à réaliser sur chaque fichier
	      if ($file=~/$rubrique.+xml$/) {
          open(FIC,"<:encoding(UTF8)",$file);
          $/=undef; #equivalent a $\=""
          my $textelu=<FIC>; # remplace la boucle while 
          close FIC;
          # Talismane 1 : initialisation du texte global contenant tous les titres et descriptions
          my $tit_des_global="";
          while ($textelu =~ /<item>.*?<title>(.+?)<\/title>.+?<description>(.+?)<\/description>/gs) {
            # memorisation des variables $1 pour la premiere parenthese, etc
            my $titre=$1;
            my $description=$2;
            ## nettoyage & qui signifie que ceci fair reference a un sous-programme
            # supprimer les bruits ht='1' src='http://rss.lemonde.fr/c/205/f/3050/s/4c93b4eb/sc/3/mf.gif'           border='0'/&gt ...
            # () est une liste en perl, cette liste reste ici et sert qu'a l'affectation
            # my $titre_nettoye=&nettoyage($titre);

            if (not exists $dico{$titre}){
            $dico{$titre}=$description;
            ($titre,$description)=&nettoyage($titre,$description);
            $tit_des_global=$tit_des_global.$titre."\n";
            $tit_des_global=$tit_des_global.$description."§\n";
            my ($titre_tagge,$description_tagge)=&etiquetage($titre,$description);
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
            print OUTXML "<titre>$titre_tagge</titre>\n";
            print OUTXML "<description>$description_tagge</description>\n";
            print OUTXML "</item>\n";
            }
          }
          # Talismane 2 : lancement du talismane sur $tit_des_global
          open(TALIS, ">:encoding(utf8)", "bao1_test.txt");
          print TALIS $tit_des_global;
          close TALIS; 
          system("java -Xmx1G -Dconfig.file=talismane-fr-5.0.4.conf -jar talismane-core-5.1.2.jar --analyse --sessionId=fr --encoding=UTF8 --inFile=bao1_test.txt --outFile=bao1_test.tal");
          # integrer le resultat de l'annotation dans le fichier global talismane
          open(TEMP, "<:encoding(utf8)", "bao1_test.tal");
          # la ligne en haut $/=undef permet de lire tout le fichier au lieu de le lire ligne a ligne
          $temp=<TEMP>;
          print OUTTALISMANE $temp;
        }
      }
    }
}
#----------------------------------------------
##################### sous-programmes (sub)
sub nettoyage {
  # @_ liste recu, pour acceder a des liste, on utilise $
  # on veut que les variables soit utilisees ici, my est obligatoire
  # shift/shift(@_) : on prend le premier element d'une liste et on le renvoie
  # my $titre=shift(@_);
  # my $description=shift(@_);
  my $titre=$_[0];
  my $description=$_[1];
  # foreach my $element(@_){

  # }
  $description =~ s/&lt;.+?&gt;//g;
  $titre =~ s/&lt;.+?&gt;//g;
  $description =~ s/&#38;&#34;/"/g;
  $titre =~ s/&#38;&#34;/"/g;
  $description =~ s/&#38;&#39;/'/g;
  $titre =~ s/&#38;&#39;/'/g;
  # $ sert a reconnaitre la fin de chaine
  $titre =~ s/$/\./g;
  return $titre,$description;
}

sub etiquetage {
  my $titre=$_[0];
  my $description=$_[1];
  open (ETI, ">:encoding(utf8)", "temporaire.txt");
  print ETI $titre;
  close ETI;
  system ("perl -f ../tokenise-utf8.pl temporaire.txt | ../tree-tagger ../french-utf8.par -token -lemma -no-unknown > temporaire.txt.pos");
  system ("perl ../treetagger2xml-utf8.pl temporaire.txt.pos utf-8"); # resultat dans le fichier temporaire.txt.pos.xml
  open (TEMP, "<:encoding(utf8)", "temporaire.txt.pos.xml");
  $/=undef;
  my $titre_tagge_xml=<TEMP>;
  close TEMP;
  # supprimer la premiere ligne <?xml..
  $titre_tagge_xml=~s/^<\?xml[^>]+>//;

  open (ETI, ">:encoding(utf8)", "temporaire.txt");
  print ETI $description;
  close ETI;
  system ("perl -f ../tokenise-utf8.pl temporaire.txt | ../tree-tagger ../french-utf8.par -token -lemma -no-unknown > temporaire.txt.pos");
  system ("perl ../treetagger2xml-utf8.pl temporaire.txt.pos utf-8"); # resultat dans le fichier temporaire.txt.pos.xml
  open (TEMP, "<:encoding(utf8)", "temporaire.txt.pos.xml");
  $/=undef;
  my $description_tagge_xml=<TEMP>;
  close TEMP;
  # supprimer la premiere ligne <?xml..
  $description_tagge_xml=~s/^<\?xml[^>]+>//;

  return $titre_tagge_xml,$description_tagge_xml;
}
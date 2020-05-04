#/usr/bin/perl
# --------BAO1 Version:Module XML::RSS----------------
# Le programme prend en entrée :
# 1. le nom du répertoire contenant les fichiers xml à traiter
# 2. le code imbriqué dans le nom du fichier servant à préciser quelle rubrique prise en compte (à la une correspond au code 3208 par ex.)
# Le programme extrait le texte dans des balises <title> et <description> et construit en sortie :
# 1. un fichier texte brut 
# 2. un fichier xml structuré
# Ce script est lancé de la manière suivante
# perl BAO1_xml_rss.pl repertoire_corpus(./2019) rubrique(3208)
#-----------------------------------------------------------

################################ programme principal
use XML::RSS;
my $rep="$ARGV[0]";
my $rubrique="$ARGV[1]";
$rep=~ s/[\/]$//;
my $i=0;
#un hash de doublons
my %doublons;
open(OUT, ">:encoding(utf-8)", "sortie-$rubrique-xmlrss.txt");
open(OUTXML, ">:encoding(utf-8)", "sortie-$rubrique-xmlrss.xml");
print OUTXML "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
print OUTXML "<racine>\n";

#----------------------------------------
&parcoursarborescencefichiers($rep);	#recurse!
close OUT;
print OUTXML "</racine>\n";
close OUTXML;
exit;
#----------------------------------------------
sub parcoursarborescencefichiers {
	my $path = shift(@_);
    opendir(DIR, $path) or die "can't open $path: $!\n";
	my @files = readdir(DIR);
    closedir(DIR);
    
	foreach my $file (@files) {
		next if $file =~ /^\.\.?$/;
		$file = $path."/".$file;
		if (-d $file) {
			&parcoursarborescencefichiers($file);	#recurse!
		}
		if (-f $file) {
		    if ($file=~/$rubrique.+\.xml$/) {			
				print $i++," : $file \n";
				my $rss=new XML::RSS;
				#parsefile ($file, \%options):analyser un fichier
				#eval():une fonction pour vérifier s'il y a des erreurs de syntaxe ou d'exéxutation, en cas d'erreur, le message d'erreur est assigné
				eval {$rss->parsefile($file); };
				if( $@ ) {
					$@ =~ s/at \/.*?$//s;               # remove module line number
					print STDERR "\nERROR in '$file':\n$@\n";
				} 
				else {
					foreach my $item (@{$rss->{'items'}}) {
						my $description=$item->{'description'};
						my $titre=$item->{'title'};
						my ($titrenettoye,$descriptionnettoye) = &nettoyage($titre,$description);
						#supprimer les doublons:
						if (exists $doublons{$titrenettoye}) {
							$doublons{$titrenettoye}++;
						}
						else {
							$doublons{$titrenettoye}=1;
							print OUT "$titrenettoye\n";
							print OUT "$descriptionnettoye\n";
							print OUTXML "<article>\n";
							print OUTXML "<titre>$titrenettoye</titre>\n";
							print OUTXML "<description>$descriptionnettoye</description>\n";
							print OUTXML "</article>\n";
						}
					}
				}		
			}
		}
    }
}

sub nettoyage {
#@_ : my ($titre,$description) = @_
	my $titre = $_[0]; 
	my $description = $_[1];
	#pour faciliter la segmentation au plus tard, on ajoute un point
	$titre = $titre . "." ; # $titre .= ".";
	$description =~ s/&#38;#39;/'/g; #$description = $description . ".";
return $titre, $description;
}
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

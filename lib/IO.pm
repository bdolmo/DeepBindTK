package IO;

use strict;
use warnings;
use List::MoreUtils qw(uniq);
use Term::ANSIColor qw(:constants);
use File::Basename;
use Cwd qw(cwd abs_path);

 our %params = (
    mode    => undef,
    genome  => undef,
    tfmodel => undef,
    size => 236,
    find_motifs => "no",
    plot    => "no",
    outdir  => undef,
    threads => undef,
 );


sub getParams {

 my $config = shift;
 if (!$config || !-e $config || -z $config) {
	print "ERROR: non-existent config file\n";
	printHelp();
	
	exit;
 }
 foreach my $param ( keys %params ) {
        my $str = `egrep ^$param $config`;
	chomp $str;

	# forcing param to be defined
        if (!$str) {
		print "ERROR: param $param not found\n";
		printHelp();
		exit;
	}
	my @tmp = split (/\t/, $str);
	$params{$param} = $tmp[1];

	if ($params{size} < 36) {
		print "ERROR: size parameter must be 36 or greater\n";
		exit;
	}
	if ($params{size} > 5000) {
		print "ERROR: size parameter must be smaller than 5000\n";  	
	}

	# Throw error if not recognized parameter option
	if ($params{plot} && $params{plot} !~/yes|no/i) {
		print "ERROR: plot parameter must be 'yes' or 'no'\n";
		printHelp();
		exit;

	}
	if ($params{find_motifs} && $params{find_motifs} !~/yes|no/i) {
		print "ERROR: find_motifs parameter must be 'yes' or 'no'\n";
		printHelp();
		exit;
	}
 }

 if (!-d $params{outdir} ) {
	mkdir $params{outdir};
 }
 return (%params);
}


sub getSamples {
 
 my $config = shift;
 my %samples = ();
 my %assoc = ();
 my %seen = ();

 # Note: grep -E provides multiple pattern match
 my $str = `egrep '(^bed|vcf)' $config`;
 chomp $str;
 my @tmpStr = split (/\n/, $str);

 if ($params{mode} eq 'full') {
        # Forcing and even mumber of paired BED-VCF files
	if ( scalar (@tmpStr) % 2 == 1) {
		print "ERROR: not properly paired BED-VCF sample files\n";
	}
	my @beds = grep ($_ =~ /bed/, @tmpStr);
	my @vcfs = grep ($_ =~ /vcf/, @tmpStr);
	
	foreach my $line (@beds) {
		my ($bed_id, $bed_name) = split (/\t/, $line);
		if ( !-e $bed_name || -z $bed_name) {
			print "ERROR: non-existent BED of peaks $bed_name\n";
			exit;
		}
		$samples{$bed_id} = $bed_name;

		$bed_id =~s/bed//;

		my $vcf_str = `egrep 'vcf$bed_id' $config`;	
		chomp $vcf_str;

		my $vcf_name;
		if ($vcf_str) {
			$vcf_name = (split /\t/, $vcf_str)[1];
			if ( !-e $vcf_name || -z $vcf_name ) {
				print "ERROR: non-existent vcf $vcf_name\n";
				exit;
			}	
		}

		if (!$vcf_str) {
			print "ERROR: not properly paired BED-VCF sample files\n";
			exit;
		}
		$seen{$bed_name}++;
		if ($seen{$bed_name} > 1) {
			print "WARNING: duplicated sample $bed_name\n";
		}
		$samples{"vcf$bed_id"} = $vcf_name;
		$assoc{$bed_name} = $vcf_name
	}	
 }
 if ($params{mode} eq 'bed') {
	my @beds = grep ($_ =~ /bed/, @tmpStr);
	foreach my $line (@beds) {
		my ($bed_id, $bed_name) = split (/\t/, $line);
		$samples{$bed_id} = $bed_name;
		$assoc{$bed_name} = $bed_name;
		$seen{$bed_name}++;
		if ($seen{$bed_name} > 1) {
			print "WARNING: duplicated sample $bed_name\n";
			exit;
		}
	}
 }
 return (\%samples, \%assoc);
}

#######################
sub printHelp {

print STDERR "Usage: ./DeepBindTK <CONFIG> 
     Params:
     -i		STRING	Configuration file.  [REQUIRED] 
     -verbose	STRING	[OPTIONAL]
     -debug	STRING	[OPTIONAL]\n\n";
exit;
}

return 1;

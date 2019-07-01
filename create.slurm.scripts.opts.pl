#! /usr/bin/perl -w

use strict;
use warnings;
use Pod::Usage;
use Getopt::Long qw(GetOptions);
use Cwd 'abs_path';

#May 12, 2016 modified from create.slurm.scripts.pl and swarm on Trek

my ($h,$file, $memory, $time, $cpu, $jobID, $type, $oneliner,$maxjobs, $mempercpu);
my $inDIR=Cwd::getcwd;
my $outDIR=Cwd::getcwd;
my $email="bwolford\@umich.edu";
my $partition="hunt";
my $exclude="hunt-mc11,hunt-mc12";

GetOptions( 'h' => \$h,
	    'f=s' => \$file,
	    'i:s' => \$inDIR,
	    'o:s' => \$outDIR,
	    'm:i' => \$memory,
	    'mpc:i' => \$mempercpu,
	    't=s' => \$time,
	    'c=i' => \$cpu,
	    'e:s' => \$email,
	    'y:s' => \$type,
	    'p:s' => \$partition,
	    'd:s' => \$exclude,
	    'l:s' => \$oneliner,
	    'x:i' => \$maxjobs,
	    'j=s' => \$jobID);
my $usage= <<USAGE;

USAGE: create.slurm.scripts.opts.pl 

    -f file (string)
    -l oneliner command (string)
    -i inDIR default is cwd
    -o outDIR default is cwd
    -m total memory (integer)
    -mpc memory per cpu (intger)
    -t time XXX:XX:XX
    -c Number of CPUs (integer)
    -e email (string)
    -x max jobs that can run at once (integer)
    -y email type (comma separated string) ex: BEGIN,END,FAIL
    -j jobID (string)
    -p partition (default is hunt) nomosix is other option, sun*, r01-r30 and c01-c52 are not pre-emptible

USAGE

#add functionality so job name is not both the .slurm.sh script and the name displayed in slurm queue
#add functionality so I can see what command is displayed in each .err or .out file
if ($h) { die "$usage";}
unless (($file || $oneliner) && ( $memory || $mempercpu)  && $time && $cpu && $jobID) { die "$usage" };

my @arr;

#take string with one command
if ($oneliner) {
    $arr[0]=$oneliner;
}


else {
#read file with commands (frequently made with for f in ...)
    my $abs_file=abs_path($file);
    open (IN, $abs_file) || die "can't open the file:$abs_file!\n";
    
    my $readline;
    undef @arr;
    
    while (defined($readline=<IN>))
    {
	chomp $readline;
	my $k = int(@arr);
	$arr[$k] = $readline;
    }
    close IN;
}

#set number of commands
my $num = int(@arr);

my $out = $outDIR."/$jobID.slurm.sh";

open (OUT,">".$out) || die "can't open the file:$out!\n";

print OUT "#!/bin/bash\n";

print OUT "#SBATCH --partition=$partition\n";
print OUT "#SBATCH --exclude=$exclude\n";
print OUT "#SBATCH --error=$outDIR/$jobID.%N_%j.%A_%a.err\n";
print OUT "#SBATCH --output=$outDIR/$jobID.%N_%j.%A_%a.out\n";
print OUT "#SBATCH --job-name=$jobID\n";
print OUT "#SBATCH --time=$time\n";
if ($memory) {
    print OUT "#SBATCH --mem=$memory"."G\n";
}
else {
    print OUT "#SBATCH --mem-per-cpu=$mempercpu"."G\n";
}

print OUT "#SBATCH --cpus-per-task=$cpu\n";

if ($maxjobs) {
    print OUT "#SBATCH --array=1-$num%$maxjobs\n"
}
else {
    print OUT "#SBATCH --array=1-$num\n";
}

if ($type){
    print OUT "#SBATCH --mail-user=$email\n";
    print OUT "#SBATCH --mail-type=$type\n";
}

print OUT "declare -a commands\n";

#print out commands from file
for (my $i = 0; $i < int(@arr); $i++) {
	my $j = $i + 1;
	print OUT "commands[$j]=\"/usr/bin/time -o $outDIR/$jobID.$j.runinfo.txt -v $arr[$i]\"\n";
}


print OUT "bash -c \"\${commands[\${SLURM_ARRAY_TASK_ID}]}\"\n";

close OUT;

print "you can use the follow cmd to submit jobs to slurm.\n";

print "sbatch $out\n";

exit(0);

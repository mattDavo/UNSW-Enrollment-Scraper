#!/usr/local/bin/perl

use strict;
use warnings;

sub get_spots {
    my ($course, $term) = @_;
    $course = uc $course;
    my $file = `wget -qO- wget http://timetable.unsw.edu.au/2019/${course}.html`;
    
    # Get relevant section
    my @relevant = split /SUMMARY OF TERM $term CLASSES/, $file;
    
    if (@relevant == 1) {
        return -1;
    }
    
    @relevant = split /<\/table/, $relevant[1], 2;

    # Get relevant table
    my @table = ();
    my $count = 0;
    my $found_first = 0;
    foreach my $line (split /\n/, $relevant[1]) {
        push @table, $line;
        my $a = () = ($line =~ /<\s*table/ig);
        my $b = () = ($line =~ /<\/\s*table/ig);
        
        $count = $count + $a - $b;
        
        if ($count > 0 && $found_first == 0) {
            $found_first = 1;
        }
        
        if ($count == 0 && $found_first == 1) {
            last;
        }
    }

    my $table = join("\n", @table);

    $table =~ /<td class="data">(\d+)\/(\d+)<\/td>/;
    my $spots = $2 - $1;
    
    return $spots;
}

my %terms = ("1" => "ONE", "2" => "TWO", "3" => "THREE");

if (@ARGV != 3 or !(@ARGV > 1 and defined $terms{$ARGV[1]})) {
    print STDERR "Usage: $0 course-code term[1|2|3] contact-email\n";
    exit 1;
}

my $course = $ARGV[0];
my $term = $terms{$ARGV[1]};
my $email = $ARGV[2];

my $prev_spots = 0;

while (1) {
    
    my $spots = get_spots("$course", "$term");
    
    if ($spots > 0) {
        print "Now $spots spots in $course!\n";
        `echo "There are now $spots spots available in $course!" | mail -s "$spots Spots available in $course" "$email"`;
        last;
    }
    elsif ($spots == -1) {
        print STDERR "$course is not offered in T$ARGV[1]\n";
        exit 1;
    }
    else {
        print "0 spots...     ".`date`;
    }
    
    sleep 5;
}

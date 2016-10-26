#!/usr/local/bin/perl
# Mike McQuade
# Longest-common-sequence.pl
# Calculates and returns the Longest Common
# Sequence between two given strings.

# Define the packages to use
use strict;
use warnings;
use List::Util qw(max);

# Initialize variables
my ($firstString,$secondString,@grid,@backtrack);

# Open the file to read
open(my $fh,"<ba5c.txt") or die $!;

# Read in the values from the file
$firstString = <$fh>;
chomp($firstString);
$secondString = <$fh>;
chomp($secondString);

# Populate the first row of the grid with as many zeros
# as the length of the second string.
my @tempArr = (0);
for (my $i = 0; $i <= length($secondString); $i++) {
	push @tempArr,0;
}
push @grid,[@tempArr];
push @backtrack,[];

# Populate the first column of the grid with as many zeros
# as the length of the first string.
for (my $i = 1; $i <= length($firstString); $i++) {
	push @grid,[0];
	push @backtrack,[];
}
# Calculate the rest of the grid
for (my $i = 1; $i <= length($firstString); $i++) {
	for (my $j = 1; $j <= length($secondString); $j++) {
		if (substr($firstString,$i-1,1) eq substr($secondString,$j-1,1)) {
			push $grid[$i], $grid[$i-1][$j-1] + 1;
		} else {push $grid[$i], max($grid[$i-1][$j], $grid[$i][$j-1])}

		# Calculate the backtrack matrix value
		if ($grid[$i][$j] == $grid[$i-1][$j-1] + 1 &&
				substr($firstString,$i-1,1) eq substr($secondString,$j-1,1)) {
			$backtrack[$i][$j] = "diagonal";
		}
		elsif ($grid[$i][$j] == $grid[$i-1][$j]) {$backtrack[$i][$j] = "down"}
		elsif ($grid[$i][$j] == $grid[$i][$j-1]) {$backtrack[$i][$j] = "right"}
	}
}

# Call the output function with the lengths of the
# given strings.
outputLCS(length($firstString),length($secondString));
print "\n";

# Close the file
close($fh) || die "Couldn't close file properly";



# Solves the Longest Common Subsequence Problem using the information
# found in the Backtrack grid.
sub outputLCS {
	my $i = $_[0];
	my $j = $_[1];

	# Define base case for recursive algorithm
	if ($i == 0 || $j == 0) {return}

	# Check the value of the given square of the matrix,
	# then call the appropriate recursive function.
	if ($backtrack[$i][$j] eq "down") {outputLCS($i-1,$j)}
	elsif ($backtrack[$i][$j] eq "right") {outputLCS($i,$j-1)}
	else { # if backtrack[$i][$j] eq "diagonal"
		outputLCS($i-1,$j-1);
		# Print out the character value of the given 
		# index of the first string.
		print substr($firstString,$i,1);
	}
}
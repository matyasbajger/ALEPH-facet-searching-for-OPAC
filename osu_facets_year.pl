#!/exlibris/aleph/a22_1/product/bin/perl
#changes years of publishing in expnaded field YRR (created bz expansion expand_doc_date_yrr) for usage in fassets.
#1. years since 2000 are left unchanged
#2. years between 1900 and 1999 are rounded to decades 1900-1909, 1910-1919, 1920-1929 ... ... 1990-1999
#3. years beitween 1000 and  1900 are rounded to centuries, like 1800-1899, 1700-1799 etc.
#4. years between 0 and 999 are changed to value '0-999'

use strict; 
use warnings;
use utf8;
binmode STDOUT, ":utf8";
#binmode STDIN, ":encoding(UTF-8)";
binmode STDIN, ":utf8";
binmode STDERR, ":utf8";
use open ":encoding(utf8)";
use Env;
$ENV{NLS_LANG} = 'AMERICAN_AMERICA.AL32UTF8';

my $bibBase='osu01';  #IMPORTANT !! SET THIS VARIABLE

our @record;
$bibBase = lc $bibBase;
my $dollar='$';
my @currTime=localtime(time);
my $currYear=$currTime[5]+1900;


while (<>) { # read lines from BIB record, one by one, and create an array containf the record
   my $line=$_;
   $line =~ s/^\s+|\s+$dollar//g;
   if ( $line eq '' ) {last;}
   #change values of YRR field(s)
   if ( $line =~ m/^YRR  / ) {
      #remove years newer than current (seen among periodicals or recs. with unlimited end-publish-year)
      my $year=$line ; $year=~ s/[^\d]//g;
      if ( $year > $currYear ) { $line =~ s/\$\$a.*$/\$\$a/; }

      $line =~ s/\$\$a19(\d)./\$\$a19$1 0-19$1 9/;
      $line =~ s/\$\$a1([0-8])../\$\$a1$1 00-1$1 99/;
      $line =~ s/\$\$a[\d]{3}$/\$\$a0-999/;
      $line =~ s/(\d)\s+/$1/g;
      $line =~ s/^YRR/FYR/g;
      }
   if ( not ($line =~ m/^$bibBase/i) ) { push (@record, $line); }
   }

#remove duplicate lines/fields
sub uniqArray { my %seen;  grep !$seen{$_}++, @_; } #got from http://perldoc.perl.org/perlfaq4.html#How-can-I-remove-duplicate-elements-from-a-list-or-array%3f
@record = uniqArray(@record);
   

#end - print results
map { print "$_\n"; } @record;




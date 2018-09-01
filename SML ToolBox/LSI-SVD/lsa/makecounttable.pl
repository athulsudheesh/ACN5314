#USAGE > perl makecounttable.pl  FileName.txt
# This code is taken from the textbook by Bilisoly
# See page 136 of Bilisoly "Practical Text Mining with Perl"
# This code belongs to Roger Bilisoly and does not belong to: RMG Consulting, Inc.
#
open(FILE,"$ARGV[0]") or die("$ARGV[0] not found");

while (<FILE>) {
    chomp;
    if ( /<TITLE>(.*)<\/TITLE>/) {
          $title = $1; # print  "TITLE = $title\n";
    }
    else
    {
    if ($title eq '') {print "NULL TITLE\n"; }
        $_ = lc;   # Change letters to lowercase
        s/--/ /g;   # Remove dashes
       s/ - / /g; # Remove dashes
       s/[,.";!()?:_\[\]]//g; # Remove non-apostrophes
       s/\s+/  /g; # Replace multiple spaces with 1 space
       s/^\s+//g; # Remove spaces at the start of a line
       @words = split(/  /);
       foreach $word (@words) {
           if ($word =~ /^'?(.*?)'?$/) { # Must be non-greedy
               $word = $1; # Remove initial and final apostrophes
               ++$freq{$title}{$word};
           }
        }
}
}

foreach $title (sort keys %freq) {
   foreach $word ( sort keys %{$freq{$title}}) {
        print "$title , $word , $freq{$title}{$word} , \n";
   }
}



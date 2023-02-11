#!/usr/bin/perl
# Script to backup databases from selected server.  Default arguements need to be set up.

use DBI;
use strict;
use Getopt::Std;

my $curtime = time();

my %opt;
getopts('h:d:c:u:p:t:P:f:l:e:i:',\%opt) || exit(66);

my $c_host = $opt{'h'} ||"localhost"; my $c_user = $opt{'u'} || "user"; my $c_pass = $opt{'p'} || "password"; my $c_port = $opt{'t'} || 3306;

my $dbh = DBI->connect("DBI:mysql:database=;host=$c_host","$c_user","$c_pass") || exit(55);

my $dirname="$c_host";

mkdir($dirname,0755);

my $q1 = "show databases";
my $r1 = $dbh->prepare($q1);
$r1->execute;
my $rowcount = $r1->rows;

my $k=0;

while (my $db = $r1->fetchrow_array) {
    $k++; # Count databases, limit to $k dumps
    if($k > 999) {
	print "Skipping $db\n";
    } else {
	print "Now dumping $c_host:$db to $c_host.$db.$curtime.dump...";
	system("/usr/bin/mysqldump --host=$c_host --user=$c_user --password=$c_pass $db > $dirname/$c_host.$db.$curtime.dump");
	print "Done!\n";
    }
}
				
print "done!\n";
				
$dbh->disconnect;
				
exit(1);

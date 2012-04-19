#!/usr/bin/perl

use strict;
use warnings;
use IO::File;
my $f = new IO::File("< field.txt");# the file contains type,name,rw/r/w
if(!$f)
{
   print("$!\n");
   exit(1);
}
#stdout -> file
open my $oldout, '>&', \*STDOUT or die "Cannot dup STDOUT: $!";
open STDOUT, '>', 'output.txt' or die "Cannot reopen STDOUT: $!";

my $line;
my @array;
while($line=<$f>)
{
   chomp($line);
   $array[@array]=[split(/,/,$line,3)];
}
my $i;
#for $i ( 0 .. $#array ) 
#{            
#	print $array[$i][0]." ".$array[$i][1]." ".$array[$i][2]."\n";
#}

#    _declspec(property(put=setName,get=getname))               
#       type name;
for $i (0..$#array)
{ 
	my $result = "_declspec(property(";
	my $type = $array[$i][0];
	my $name = $array[$i][1];
	my $rw   = $array[$i][2];
	if ($rw =~ /w/)
	{
		$result = $result."put=set".$name.",";
	}
	if($rw =~ /r/)
	{
	$result = $result."get=get".$name."))";
	}
	$result = $result."\n    ".$type."  ".$name.";\n";
	print $result;
}
#  void            setProgress(unsigned long inPercentDone);
#unsigned char   getProgress() const;
for $i (0..$#array)
{ 
	
	my $type = $array[$i][0];
	my $name = $array[$i][1];
	my $rw   = $array[$i][2];
	my $result ="";
	if ($rw =~ /w/)
	{
		#w
		$result = $result."void    set".$name."(".$type." in".$name.");\n";
	}	
	if($rw =~ /r/)
	{
		#r
		$result = $result.$type."    get".$name."() const;\n";
	}
	print $result;
}
#file -> stdout
open STDOUT, '>&', $oldout or die "Cannot dup \$oldout: $!";
my $status = system( "notepad.exe output.txt" );
if ($status != 0)
{
	print "Failed to open output.txt";
	exit -1;
} else {
	print "Success to open output.txt,please check it !";
}
exit 0;
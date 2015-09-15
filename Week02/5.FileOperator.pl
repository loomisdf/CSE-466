#! /usr/bin/perl
# file name: 5.FileOperator.pl
# This code shows you how to use file operator 

print "Enter your file or directory name here ...\n";
$fileOrDirectory=<STDIN>;
#chomp($fileOrDirectory);

if (-e $fileOrDirectory) {
   print " $fileOrDirectory was found in the current folder\n";
}
else {
   print " $fileOrDirectory does not exist in the current folder\n";
}

if (-d $fileOrDirectory){
  print " $fileOrDirectory is a directory\n";
}
else{
  print " $fileOrDirectory is not a directory\n";
}

if (-f $fileOrDirectory){
  print " $fileOrDirectory is a file\n";
}
else{
  print " $fileOrDirectory is not a file\n";
}

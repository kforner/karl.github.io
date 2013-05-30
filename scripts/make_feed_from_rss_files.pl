#! /usr/bin/env perl
use strict;
use warnings;

use JSON;
use XML::RSS;
use DateTime;
use File::Slurp;
use DDP;

my ($base_url, $posts_url, $stylesheet) = @ARGV;
die 'give base_url, posts_url, [sylesheet_url]' unless $posts_url;
#my $DIR = shift @ARGV;
#die 'give directory' unless $DIR;

my @lines = <STDIN>;
my $json = join('', @lines);

my $payload = decode_json( $json );


my $pages = $payload->{pages};

#my @posts = grep { $_->{file} =~ /^$DIR\//} @$pages;
my @posts = @$pages;


my $rss = XML::RSS->new(version => '2.0', stylesheet  => $stylesheet);
$rss->channel(
   title        => "karl's blog",
   link         => $base_url,
   description  => "R-related blog",
   lastBuildDate => DateTime->now . ""
 );
 
 foreach my $post (@posts) {
 	my $dt = DateTime->from_epoch(epoch => $post->{date}*3600*24);
 	my @k =keys %$post; 
 
# 	my $html_file = "$DIR/" . $post->{filename} . ".html";
	my $html_file = $post->{filename} . ".html";
 	my $html = read_file($html_file);
 	
	$rss->add_item(title => $post->{title},
			description => $html,
	        link => $posts_url ."/" . $post->{link},
	        dc => { subject => $post->{tags}, date=>"$dt" }
	);
 }
 
 print $rss->as_string, "\n";
 

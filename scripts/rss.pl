#! /usr/bin/env perl
use strict;
use warnings;

use JSON;
use XML::RSS;
use DDP;

my @lines = <>;
my $json = join('', @lines);

my $payload = decode_json( $json );


my $pages = $payload->{pages};

my @posts = grep { $_->{file} =~ /^posts\//} @$pages;


my $base = "http://kforner.github.io";

my $rss = XML::RSS->new(version => '2.0');
$rss->channel(
   title        => "karl's blog",
   link         => $base,
   description  => "R-related blog",
 );
 
 foreach my $post (@posts) {
	$rss->add_item(title => $post->{title},
			description => $post->{summary},
	        link => $base . "/" . $post->{link}
	        
	);
 }
 
 print $rss->as_string, "\n";
 

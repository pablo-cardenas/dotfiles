#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

use Text::BibTeX;

my $bibpath = $ARGV[0];
my $bibfile = Text::BibTeX::File->new($bibpath);

while (my $entry = Text::BibTeX::Entry->new($bibfile)) {
	next unless $entry->parse_ok;
	next unless $entry->metatype eq BTE_REGULAR;
	my $key = $entry->key;
	my $title = $entry->get('title');
	my $author = $entry->get('author');

	my $url;
	if ($entry->exists('doi')) {
		$url = $entry->get('doi');
	} elsif ($entry->exists('url')){
		$url = $entry->get('url');
	}
	else {
		next;
	}

	print "$url - $title - $author\n";
}

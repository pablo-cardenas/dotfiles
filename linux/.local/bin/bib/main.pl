#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

use Text::BibTeX;

my $bibfile = Text::BibTeX::File->new('/home/pablo/Documents/references/references.bib');
my $entry;

while ($entry = Text::BibTeX::Entry->new($bibfile)) {
	next unless $entry->parse_ok;
	next unless $entry->metatype eq BTE_REGULAR;
	my $key = $entry->key;
	my $title = $entry->get('title');
	my $author = $entry->get('author');
	print "$key - $title - $author\n";
}

#!/usr/bin/perl

use CGI;

my $q = CGI->new;

# get a copy of all the headers sent with the request
my %headers = map { $_ => $q->http($_) } $q->http();

print $q->header();
print $q->start_html('SSL Sucks');
if ($q->https()) {
	print $q->h1('Secure Connection') . "\n";
} else {
	print $q->h1('Unsecure Connection') . "\n";
}

print $q->h2("Data headers sent") . "\n";
for my $header ( keys %headers ) {
	if ($header =~ /HTTP_X_CUSTOM_/) {
		print $q->p("$header: $headers{$header}") . "\n";
	}
}
print $q->end_html;

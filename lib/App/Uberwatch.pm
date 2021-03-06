package App::Uberwatch;

use 5.006;
use strict;
use warnings FATAL => 'all';

use Moose;
use YAML qw(LoadFile Dump);
use Log::Handler;
use Proc::Daemon;
use Getopt::Long;
use Parallel::ForkManager;
use App::Uberwatch::Utils;
use App::Uberwatch::Server;

$| = 1;

my $config = '';
my $debug = '';
my $verbose = '';
my $server;

=head1 NAME

App::Uberwatch - server/process monitoring easy as...you know what

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use App::Uberwatch;

    my $foo = App::Uberwatch->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 ATTRIBUTES

=head2 config_file

=cut

has 'config_file' => (
	is => 'rw',
#	isa => 'Path::Class::File'
	isa => 'Str',
    default => "./config.yml"
);

has 'config' => (
    is => 'rw',
);

has 'pm' => (
	is => 'rw'
);

has 'log' => (
	is => 'rw'
);

has 'server' => (
	is => 'rw'
);

has 'utils' => (
    is => 'rw'
);

=head1 SUBROUTINES/METHODS

=head2 run

Main method, creates a fork for every server/process to be monitored

=cut
sub run {
	my $self = shift;
    my @thread;

    GetOptions(
        'config=s', \$config,
        'debug' => \$debug,
        'verbose' => \$verbose
    );

    $self->config_file($config) if ($config !~ '');

    confess "Config file " . $self->config_file . " does not exists!" if (! -e $self->config_file);

    $self->config(LoadFile($self->config_file));
    my $config = $self->config();

    $self->utils(App::Uberwatch::Utils->new(
            debugmode => $debug, 
            verbosemode => $verbose)
    );
    $self->utils->warning("Verbose mode activated, logging everything!\n") if ($verbose =~ '1');

    # Create the ForkManager with only as much forks as hosts defined in
    # the config file
    my $pm = new Parallel::ForkManager(scalar $config);

    for (my $i = 0; $i < scalar @{$config}; $i++) {
        $self->utils->debug($config->[$i]->{'host'} . "\n");

        $pm->start and next;

        # Create log files for each host
        $self->log(Log::Handler->create_logger($config->[$i]->{'host'}));
        $self->log->add(
            file => {
                filename => $config->[$i]->{'logfile'},
                minlevel => 'emergency',
                maxlevel => 'debug'
            }
        );

        # Start the monitoring process
        &monitor($self, $config->[$i]);
	}
}


=head2 monitor

The main monitoring function, checks every n seconds the specified server
with the specified methods

=cut

sub monitor {
    my $self = shift;
    my $config = shift;

    $server = App::Uberwatch::Server->new(verbosemode => $verbose);
    $server->init($config);

	for (;;) {
	    my $start = time;

	    if ((my $remaining = $config->{'interval'} - (time - $start)) > 0) {
            $server->ping_server if defined $config->{'methods'}->{'ping'};
            $server->http_server if defined $config->{'methods'}->{'http'};
	        sleep $remaining;
	    }
	}
}


=head1 AUTHOR

Alexander Kluth, C<< <contact at alexanderkluth.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-uberwatch at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-Uberwatch>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::Uberwatch


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-Uberwatch>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-Uberwatch>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-Uberwatch>

=item * Search CPAN

L<http://search.cpan.org/dist/App-Uberwatch/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Alexander Kluth.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of App::Uberwatch

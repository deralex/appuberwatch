App::Uberwatch - server/process monitoring easy as...you know what
===========

ABOUT
----------------
App::Uberwatch is a simple yet effective server/process monitoring tool which aims to be extremely easy to setup and configure. All you want to do is to write a simple config file in the YAML format and you're ready to monitor your servers.


Info: App::Uberwatch is in an early stadium, it's ready to use but still buggy and the code (especially the Moose parts) needs some improvements.

INSTALLATION
----------------

To install this module, run the following commands:

	perl Makefile.PL
	make
	make test
	make install

CONFIGURATION
----------------
Everything is configured via a simple, yet effective configuration file in the YAML format. You can specify the configuration file either at the command prompt via `--config=/path/to/config.yml` or you can use the system-wide configuration stored at `/etc/uberwatch/config.yml`.

Here's a sample configuration setup for two hosts:

	- 
  	    host: mysuperduper.fancyhost.com
	    interval: 10
  	    methods: 
    	    	ping: 
       				method: tcp
	 	      		timeout: 10
  		logfile: /tmp/fancyhost.com.log
	-
		host: checkthis.hothost.de
	  	interval: 5
	  	methods:
	    		http:
			      	timeout: 60
	  	logfile: /tmp/hothost.com.log

The `interval` and `timeout` are defined as seconds. Per default uberwatch is only logging warnings and errors. For verbose logging (which may result in huge logfiles!) run uberwatch with the `--verbose` command.

RUN
----------------
After installing and creating a config.yml file, you can run uberwatch from your command prompt:

		uberwatch

You can specify the configuration on the commandline:

		uberwatch --config=/path/to/config.yml

To enable verbose output in the logging files, use the `--verbose` switch:

		uberwatch --verbose



SUPPORT AND DOCUMENTATION
------------------------
After installing, you can find documentation for this module with the
perldoc command.

    perldoc App::Uberwatch

You can also look for information at:

    RT, CPAN's request tracker (report bugs here)
        http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-Uberwatch

    AnnoCPAN, Annotated CPAN documentation
        http://annocpan.org/dist/App-Uberwatch

    CPAN Ratings
        http://cpanratings.perl.org/d/App-Uberwatch

    Search CPAN
        http://search.cpan.org/dist/App-Uberwatch/


LICENSE AND COPYRIGHT
-----------------------

Copyright (C) 2013 Alexander Kluth

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


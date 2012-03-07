#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

use lib '../lib';
use Mailgun;


my $mg = Mailgun->new({ 
    key => 'key-2hic097u1i9gyw1-3esz5l4qu5aluq49',
    domain => 'rblt.mailgun.org',
    from => 'devels <devels@rblt.mailgun.org>'
});


print Dumper $mg->complaints;
#print Dumper $mg->unsubscribe('get','gtsafas@rblt.com');
#print Dumper $mg->unsubscribes('del','gtsafas@rblt.com');
#print Dumper $mg->unsubscribes('post',{address => 'gtsafas@rblt.com', tag => '*'});

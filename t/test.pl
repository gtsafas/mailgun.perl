#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

use lib '../lib';
use Mailgun;


my $mg = Mailgun->new({ 
    key => 'key-',
    domain => 'elbowrage.mailgun.org',
    from => 'elb0w <elb0w@elbowrage.mailgun.org>'
});


$mg->unsubscribes;

$mg->send({
      to => 'some_email@gmail.com',
      subject => 'hello',
      text => 'test',
      html => '<html><h3>hello</h3><strong>world</strong></html>',
      attachment => ['/Users/elb0w/GIT/Personal/Mailgun/test.pl']
  
});

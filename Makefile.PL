#!/usr/bin/env perl

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'WWW::Mailgun',
  VERSION_FROM => 'lib/Net/Mailgun.pm',
  PREREQ_PM    => {},
  AUTHOR       => 'George Tsafas <elb0w@elbowrage.com>'
);

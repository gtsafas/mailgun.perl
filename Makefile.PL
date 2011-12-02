#!/usr/bin/env perl

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mailgun',
  VERSION_FROM => 'lib/Mailgun.pm',
  PREREQ_PM    => {},
  AUTHOR       => 'George Tsafas <elb0w@elbowrage.com>'
);

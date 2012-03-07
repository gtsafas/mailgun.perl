#!/usr/bin/env perl

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'WWW::Mailgun',
  VERSION_FROM => 'lib/WWW/Mailgun.pm',
  PREREQ_PM    => {'JSON' => 0, 'Digest::SHA1' => 0, 'LWP::UserAgent' => 0, 'MIME::Base64' => 0},
  AUTHOR       => 'George Tsafas <elb0w@elbowrage.com>'
);

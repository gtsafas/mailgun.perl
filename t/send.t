#!/usr/bin/perl

use LWP::UserAgent;
use JSON;
use Test::MockModule;
use Test::More;
use Test::Deep;
use WWW::Mailgun;

my $msg = {
    from        => "sender\@acme.com",
    to          => "recipient\@acme.com",
    subject     => "Hello, World",
    text        => "MailGun is a set of powerful APIs that enable you to ".
                   "send, receive and track email effortlessly.",
    attachments => [ 'hello.txt', 'world.xml' ],
    tags        => [ 'perl', 'mailgun' ],
};

my $ua = new Test::MockModule('LWP::UserAgent');
$ua->mock(post => sub {
    my ($self, $uri, %headers_and_content) = @_;

    is(
        $uri,
        "https://api.mailgun.net/v2/samples.mailgun.org/messages",
        "URI is correct"
    );

    is(
        $headers_and_content{Content_Type},
        "multipart/form-data",
        "Content-Type is correct",
    );

    my @content = @{$headers_and_content{Content}};
    my $hash = {};
    while ( @content ) {
        my $key = shift @content;
        my $value = shift @content;
        if ($hash->{$key}) {
            $hash->{$key} = [$hash->{$key}];
            push @{$hash->{$key}}, $value;
        }
        else {
            $hash->{$key} = $value;
        }
    }

    is_deeply(
        $hash,
        {
            'from'       => $msg->{from},
            'to'         => $msg->{to},
            'subject'    => $msg->{subject},
            'text'       => $msg->{text},
            'attachment' => [ 'hello.txt', 'world.xml' ],
            'o:tag'      => [ 'perl', 'mailgun' ],
        },
        "Content is correct",
    );

    return HTTP::Response->new(200, "OK", [], to_json({}));
});

WWW::Mailgun->new({
    key    => 'key-3ax6xnjp29jd6fds4gc373sgvjxteol0',
    domain => 'samples.mailgun.org',
    ua     => $ua,
})->send($msg);

done_testing;

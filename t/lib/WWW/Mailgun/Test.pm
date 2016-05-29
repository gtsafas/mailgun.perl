package WWW::Mailgun::Test;

use Test::Most;

use List::Util qw/first/;
use LWP::UserAgent;
use WWW::Mailgun;

sub new {
    my $class = shift;

    my $self = {};

    my $ua = LWP::UserAgent->new();
    $ua->add_handler(response_done => sub {
        my ($response) = @_;
        $self->{response} = $response;
        $self->{request} = $response->request;
        return undef;
    });

    $self->{mg} = WWW::Mailgun->new({
        key    => 'key-3ax6xnjp29jd6fds4gc373sgvjxteol0',
        domain => 'samples.mailgun.org',
        from   => 'test@samples.mailgun.org',
        ua     => $ua,
    });

    return bless($self, $class);
}

sub assert_request_part {
    my $self = shift;
    my ($name, $part_as_string) = @_;

    my $part = first {
        $_->header("Content-Disposition") =~ m/name="$name"/
    } $self->{request}->parts;

    is(
        $part->as_string,
        $part_as_string,
        "Got expected request part ($name) => ($part_as_string)",
    );
}

sub assert_send {
    my $self = shift;
    my $res = $self->{mg}->send(@_);

    cmp_deeply($res, {
        message => 'Queued. Thank you.',
        id => re(qr/<[\w\.]+\@samples\.mailgun\.org>/),
    }, "Message was queued.");

    return $res;
}


1;

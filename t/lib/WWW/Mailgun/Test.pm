package WWW::Mailgun::Test;

use Test::Most;

use File::Temp;
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
    my ($part_as_string) = @_;

    ok(
        $self->_get_matching_parts($part_as_string),
        "Found part ($part_as_string).",
    );
}

sub _get_matching_parts {
    my $self = shift;
    my ($part_as_string) = @_;

    return
        grep { $_ eq $part_as_string }
        map { $_->as_string }
        $self->{request}->parts;
}

sub assert_no_request_part {
    my $self = shift;
    my ($part_as_string) = @_;

    ok(
        !$self->_get_matching_parts($part_as_string),
        "Did not find part ($part_as_string).",
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

sub new_file_temp {
    my ($self) = shift;
    my ($ext, $content) = @_;

    my $handle = File::Temp->new(suffix => ".$ext");
    my $path = $handle->filename;
    my ($name) = $path =~ m/(\w+\.$ext)$/;

    print $handle $content if $content;
    close $handle;

    return {
        path => $path,
        name => $name,
        handle => $handle,
    };
}


1;

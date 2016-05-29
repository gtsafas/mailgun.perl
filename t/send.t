use Test::Most;

use WWW::Mailgun::Test;

my $mg = WWW::Mailgun::Test->new();

my $txt_file = $mg->new_file_temp("txt", "Hello, world.");
my $txt_filename = $txt_file->{name};

my $xml_file = $mg->new_file_temp("xml", "<hello>world</hello>");
my $xml_filename = $xml_file->{name};

$mg->assert_send({
    'to'          => 'test-recipient@samples.mailgun.org',
    'subject'     => "Hello, World",
    'text'        => "MailGun is a set of powerful APIs that enable you to ".
                    "send, receive and track email effortlessly.",
    'attachments' => [ $xml_file->{path}, $txt_file->{path} ],
    'o:tag'       => [ 'perl', 'mailgun', 'ruby', 'python' ],
});

for (qw/perl mailgun ruby/) {
    $mg->assert_request_part(<<"END"
Content-Disposition: form-data; name="o:tag"

$_
END
    );
}

$mg->assert_no_request_part(<<END
Content-Disposition: form-data; name="o:tag"

python
END
);

$mg->assert_request_part(<<"END"
Content-Type: application/xml
Content-Disposition: form-data; name="attachment"; filename="$xml_filename"

<hello>world</hello>
END
);

assert_txt_file_part();

$mg->assert_request_part(<<END
Content-Disposition: form-data; name="text"

MailGun is a set of powerful APIs that enable you to send, receive and track email effortlessly.
END
);

$mg->assert_send({
    to => 'test-recipient@samples.mailgun.org',
    subject => 'hello',
    html => '<html><h3>hello</h3><strong>world</strong></html>',
    attachment => [$txt_file->{path}],
});

assert_txt_file_part();
assert_html_part();

$mg->assert_send({
    to => 'test-recipient@samples.mailgun.org',
    subject => 'hello',
    html => '<html><h3>hello</h3><strong>world</strong></html>',

    # Module users shouldn't have to know that attachments need to be in an
    # array.
    attachment => $txt_file->{path},
});

assert_txt_file_part();
assert_html_part();

sub assert_txt_file_part {
    $mg->assert_request_part(<<"END"
Content-Type: text/plain
Content-Disposition: form-data; name="attachment"; filename="$txt_filename"

Hello, world.
END
    );
}

sub assert_html_part {
    $mg->assert_request_part(<<"END"
Content-Disposition: form-data; name="html"

<html><h3>hello</h3><strong>world</strong></html>
END
    );
}

done_testing;

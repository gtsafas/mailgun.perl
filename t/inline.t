use Test::Most;

use WWW::Mailgun::Test;

my $mg = WWW::Mailgun::Test->new();

my $file = $mg->new_file_temp("jpg");
my $filename = $file->{name};

$mg->assert_send({
    to => 'test-recipient@samples.mailgun.org',
    text => "Hello, world.",
    html => "<html>Inline image here: <img src=\"$filename\"></html>",
    inline => $file->{path},
});

$mg->assert_request_part(<<"END"
Content-Disposition: form-data; name="html"

<html>Inline image here: <img src="$filename"></html>
END
);

$mg->assert_request_part(<<"END"
Content-Type: image/jpeg
Content-Disposition: form-data; name="inline"; filename="$filename"

END
);

done_testing;

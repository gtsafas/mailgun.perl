use Test::Most;

use WWW::Mailgun::Test;
use File::Temp;

my $fh = File::Temp->new(suffix => ".jpg");
my $filepath = $fh->filename;
my ($filename) = $filepath =~ m/(\w+\.jpg)$/;

my $mg = WWW::Mailgun::Test->new();

$mg->assert_send({
    to => 'test-recipient@samples.mailgun.org',
    text => "Hello, world.",
    html => "<html>Inline image here: <img src=\"$filename\"></html>",
    inline => $filepath,
});

$mg->assert_request_part(html => <<"END"
Content-Disposition: form-data; name="html"

<html>Inline image here: <img src="$filename"></html>
END
);

$mg->assert_request_part(inline => <<"END"
Content-Type: image/jpeg
Content-Disposition: form-data; name="inline"; filename="$filename"

END
);

done_testing;

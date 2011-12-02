Mailgun - Perl (Module name subject to change)
===================
#### Perl bindings for Mailgun (http://mailgun.org)

### SYNOPSIS

    use Mailgun;


### DESCRIPTION

Mailgun is a email service which provides email over a http restful API.
These bindings goal is to create a perl interface which allows you to
easily leverage it.

    use Mailgun;

    my $mg = Mailgun->new({ 
        key => 'key-yOuRapiKeY',
        domain => 'YourDomain.mailgun.org',
        from => 'elb0w <elb0w@YourDomain.mailgun.org>' # Optionally set here, you can set it when you send
    });

    # Send a HTML message with attachments
    #
    $mg->send({
          to => 'some_email@gmail.com',
          subject => 'hello',
          html => '<html><h3>hello</h3><strong>world</strong></html>',
          attachment => ['/Users/elb0w/GIT/Personal/Mailgun/test.pl']
    });

    # Send a text message
    $mg->send({
          to => 'some_email@gmail.com',
          subject => 'hello',
          text => 'Hello there',
    });


    #Simple calls return an object with various stats

    my $obj = $mg->unsubscribes; 
    my $obj = $mg->complaints;
    my $obj = $mg->bounces; 
    my $obj = $mg->stats; 
    my $obj = $mg->logs; 
    my $obj = $mg->mailboxes;


### USAGE

#### new({key => 'mailgun key', domain => 'your mailgun domain', from => 'optional from')

Creates your mailgun object

from => the only optional field, it can be set in the message.



#### send(mail)

Send takes in a hash of settings
...

#### TODO

Rest of the docs and tests as im tired.

#### Author

George Tsafas <elb0w@elbowrage.com>


#### Support

elb0w on irc.freenode.net #perl




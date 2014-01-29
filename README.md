# NAME

POE::Component::WWW::Lipsum - non-blocking wrapper around WWW::Lipsum

# SYNOPSIS

    use strict;
    use warnings;

    use POE qw/Component::WWW::Lipsum/;

    my $poco = POE::Component::WWW::Lipsum->spawn;

    POE::Session->create( package_states => [ main => [qw/_start lipsum/] ], );

    $poe_kernel->run;

    sub _start {
        $poco->generate({
                event => 'lipsum',
                args  => {
                    amount => 5,
                    what   => 'paras',
                    start  => 0,
                    html   => 1
                },
            }
        );
    }

    sub lipsum {
        my $in_ref = $_[ARG0];

        print "$_\n" for @{ $in_ref->{lipsum} };

        $poco->shutdown;
    }

    # Using event based interface is also possible of course.

# DESCRIPTION

The module is a non-blocking wrapper around [WWW::Lipsum](https://metacpan.org/pod/WWW::Lipsum)
which provides interface to retrieve lipsum text from [http://lipsum.com/](http://lipsum.com/)

# CONSTRUCTOR

## `spawn`

    my $poco = POE::Component::WWW::Lipsum->spawn;

    POE::Component::WWW::Lipsum->spawn(
        alias => 'lipsum',
        options => {
            debug => 1,
            trace => 1,
            # POE::Session arguments for the component
        },
        debug => 1, # output some debug info
    );

The `spawn` method returns a
POE::Component::WWW::Lipsum object. It takes a few arguments,
_all of which are optional_. The possible arguments are as follows:

### `alias`

    ->spawn( alias => 'lipsum' );

__Optional__. Specifies a POE Kernel alias for the component.

### `options`

    ->spawn(
        options => {
            trace => 1,
            default => 1,
        },
    );

__Optional__.
A hashref of POE Session options to pass to the component's session.

### `debug`

    ->spawn(
        debug => 1
    );

When set to a true value turns on output of debug messages. __Defaults to:__
`0`.

# METHODS

## `generate`

    $poco->generate( {
            event       => 'event_for_output',
            args        => {
                amount => 5,
                what   => 'paras',
                start  => 0,
                html   => 1,
            },
            _blah       => 'pooh!',
            session     => 'other',
        }
    );

Takes a hashref as an argument, does not return a sensible return value.
See `generate` event's description for more information.

## `session_id`

    my $poco_id = $poco->session_id;

Takes no arguments. Returns component's session ID.

## `shutdown`

    $poco->shutdown;

Takes no arguments. Shuts down the component.

# ACCEPTED EVENTS

## `generate`

    $poe_kernel->post( lipsum => generate => {
            event       => 'event_for_output',
            args        => {
                amount => 5,
                what   => 'paras',
                start  => 0,
                html   => 1,
            },
            _blah       => 'pooh!',
            session     => 'other',
        }
    );

Instructs the component to fetch some Lorem Ipsum text
from [http://lipsum.com/](http://lipsum.com/). Takes a hashref as an
argument, the possible keys/value of that hashref are as follows:

### `event`

    { event => 'results_event', }

__Mandatory__. Specifies the name of the event to emit when results are
ready. See OUTPUT section for more information.

### `args`

    {
        args => {
            amount => 5,
            what   => 'paras',
            start  => 0,
            html   => 1,
        },
    }

__Mandatory__. The `args` key takes a hashref as its value. This hashref
will be directly dereferenced into [WWW::Lipsum](https://metacpan.org/pod/WWW::Lipsum) `generate()` method.
See documentation for [WWW::Lipsum](https://metacpan.org/pod/WWW::Lipsum) for possible arguments.

### `session`

    { session => 'other' }

    { session => $other_session_reference }

    { session => $other_session_ID }

__Optional__. Takes either an alias, reference or an ID of an alternative
session to send output to.

### user defined

    {
        _user    => 'random',
        _another => 'more',
    }

__Optional__. Any keys starting with `_` (underscore) will not affect the
component and will be passed back in the result intact.

## `shutdown`

    $poe_kernel->post( lipsum => 'shutdown' );

Takes no arguments. Tells the component to shut itself down.

# OUTPUT

    $VAR1 = {
        'args' => {
            'amount' => 2,
            'html' => 1,
            'what' => 'paras',
            'start' => 'no'
        },
        'lipsum' => [
            '<p>Lipsum text here</p>',
            '<p>Lipsum text here (cut for brevity)</p>',
        ],
        _user => 'defined args',
    };

The event handler set up to handle the event which you've specified in
the `event` argument to `generate()` method/event will receive input
in the `$_[ARG0]` in a form of a hashref. The possible keys/value of
that hashref are as follows:

## `lipsum`

    {
        'lipsum' => [
            '<p>Lipsum text here</p>',
            '<p>Lipsum text here (cut for brevity)</p>',
        ],
    }

The `lipsum` key will contain an _arrayref_ elements of which will be
the generated Lorem Ipsum text. Note: if an error occurred the `lipsum`
key will __not__ be present. See `error` below.

## `error`

    {
        'error' => 'Error: message',
    },

In case of an error the [lipsum](https://metacpan.org/pod/lipsum) key will not be present and an
`error` key will be present instead which will contain an error
message describing the problem. __Note:__ at the time of this
writing there is a minor
bug in [WWW::Lipsum](https://metacpan.org/pod/WWW::Lipsum) due to which any errors related to
[LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent) will not return an appropriate error message, just
the text "Error: ". The bug report has been posted and may be fixed already.

## `args`

        'args' => {
            'amount' => 2,
            'html' => 1,
            'what' => 'paras',
            'start' => 0,
        },

The `args` key will contain the same hashref that you passed to
`generate()` event/method `args` argument.

## user defined

    { '_blah' => 'foos' }

Any arguments beginning with `_` (underscore) passed into the `generate()`
event/method will be present intact in the result.

# SEE ALSO

[POE](https://metacpan.org/pod/POE), [WWW::Lipsum](https://metacpan.org/pod/WWW::Lipsum)

head1 REPOSITORY

Fork this module on GitHub:
[https://github.com/zoffixznet/WWW-Lipsum](https://github.com/zoffixznet/WWW-Lipsum)

# BUGS

To report bugs or request features, please use
[https://github.com/zoffixznet/WWW-Lipsum/issues](https://github.com/zoffixznet/WWW-Lipsum/issues)

If you can't access GitHub, you can email your request
to `bug-www-lipsum at rt.cpan.org`

# AUTHOR

Zoffix Znet <zoffix at cpan.org>
([http://zoffix.com/](http://zoffix.com/), [http://haslayout.net/](http://haslayout.net/))

# LICENSE

You can use and distribute this module under the same terms as Perl itself.
See the `LICENSE` file included in this distribution for complete
details.

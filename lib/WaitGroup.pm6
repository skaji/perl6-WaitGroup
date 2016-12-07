use v6;
unit class WaitGroup;

has $!channel = Channel.new;
has $!count = 0;
# has $!lock = Lock.new;

method add(Int $delta) {
    $!count += $delta;
}

method done {
    $!channel.send(True);
}

method wait {
    while $!count > 0 {
        $!channel.receive;
        $!count--;
    }
}

=begin pod

=head1 NAME

WaitGroup - like sys.WaitGroup in golang

=head1 SYNOPSIS

    use WaitGroup;
    use HTTP::Tinyish;

    my $wg = WaitGroup.new;

    my @url = <
        http://www.golang.org/
        http://www.google.com/
        http://www.somestupidname.com/
    >;

    for @url -> $url {
        $wg.add(1);
        start {
            LEAVE $wg.done;
            my $res = HTTP::Tinyish.new.get($url, :bin);
            note "-> {$res<status>}, $url";
        };
    }

    $wg.wait;


=head1 DESCRIPTION

WaitGroup waits for a collection of promises to finish.

=head1 SEE ALSO

L<https://golang.org/pkg/sync/#WaitGroup>

=head1 TODO

Lock

=head1 AUTHOR

Shoichi Kaji <skaji@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2016 Shoichi Kaji

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

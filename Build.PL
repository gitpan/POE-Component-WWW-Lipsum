use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'POE::Component::WWW::Lipsum',
    license             => 'perl',
    dist_author         => 'Zoffix Znet <zoffix@cpan.org>',
    dist_version_from   => 'lib/POE/Component/WWW/Lipsum.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'POE::Component::NonBlockingWrapper::Base' => 0.002,
        'WWW::Lipsum'                              => 0.2,
    },
    add_to_cleanup      => [ 'POE-Component-WWW-Lipsum-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();

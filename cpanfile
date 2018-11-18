requires "Ref::Util" => "0";
requires "Safe::Isa" => "0";
requires "Types::SQL::Util" => "v0.3.0";
requires "namespace::autoclean" => "0";
requires "perl" => "v5.8.0";
requires "version" => "0";
recommends "Ref::Util::XS" => "0";
recommends "Type::Tiny::XS" => "0";

on 'test' => sub {
  requires "DBD::SQLite" => "0";
  requires "DBIx::Class::Core" => "0";
  requires "DBIx::Class::Schema" => "0";
  requires "File::Spec" => "0";
  requires "Module::Metadata" => "0";
  requires "SQL::Translator" => "0.11018";
  requires "Test::More" => "0";
  requires "Test::Most" => "0";
  requires "Types::SQL" => "v0.3.0";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};

on 'develop' => sub {
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::CleanNamespaces" => "0.15";
  requires "Test::EOF" => "0";
  requires "Test::EOL" => "0";
  requires "Test::Kwalitee" => "1.21";
  requires "Test::MinimumVersion" => "0";
  requires "Test::More" => "0.88";
  requires "Test::NoTabs" => "0";
  requires "Test::Perl::Critic" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Pod::LinkCheck" => "0";
  requires "Test::Portability::Files" => "0";
  requires "Test::TrailingSpace" => "0.0203";
};

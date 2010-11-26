package AssetPathFix::CMS;

use strict;
use warnings;
use MT 4.0;

# use Data::Dumper;

sub path_tor {
    my ($app) = @_;
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        require MT::Blog;
        my $blog = MT::Blog->load($blog_id);
        my $site_path = $blog->site_path;
        $site_path =~ s!\\!/!g;
        my $site_url = $blog->site_url;
        my @ids = $app->param('id');
        require MT::Asset;
        foreach my $id (@ids) {
            my $asset = MT::Asset->load($id);
            if ( $asset->class =~ /image|audio|video|file/) {
                my $file_path = $asset->file_path;
                $file_path =~ s!\\!/!g;
                $file_path =~ s!$site_path!%r!;
                $asset->file_path( $file_path );
                my $file_url = $asset->url;
                $file_url =~ s!\\!/!g;
                $file_url =~ s!$site_url!%r/!;
                $asset->url( $file_url );
                $asset->save;
            }
        }
        $app->call_return( modified => 1 );
    }
}

sub flatten_path {
    my ($app) = @_;
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        require MT::Blog;
        my $blog = MT::Blog->load($blog_id);
        my $site_path = $blog->site_path;
        $site_path =~ s!\\!/!g;
        my $site_url = $blog->site_url;
        my @ids = $app->param('id');
        require MT::Asset;
        foreach my $id (@ids) {
            my $asset = MT::Asset->load($id);
            if ( $asset->class =~ /image|audio|video|file/) {
                my $file_path = $asset->file_path;
                $file_path =~ s!\\!/!g;
                $file_path =~ s!%r!$site_path!;
                $asset->file_path( $file_path );
                my $file_url = $asset->url;
                $file_url =~ s!\\!/!g;
                $file_url =~ s!%r/!$site_url!;
                $asset->url( $file_url );
                $asset->save;
            }
        }
        $app->call_return( modified => 1 );
    }
}

sub fix_url {
    my ($app) = @_;
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        require MT::Blog;
        my $blog = MT::Blog->load($blog_id);
        my $site_path = $blog->site_path;
        $site_path =~ s!\\!/!g;
        my $site_url = $blog->site_url;
        my @ids = $app->param('id');
        require MT::Asset;
        foreach my $id (@ids) {
            my $asset = MT::Asset->load($id);
            if ( $asset->class =~ /image|audio|video|file/) {
                my $file_path = $asset->file_path;
                $file_path =~ s!\\!/!g;
                $file_path =~ s!$site_path!!;
                my $url = $site_url . $file_path;
                $url =~ s!$site_url!%r/!;
                $url =~ s!//!/!;
                $asset->url( $url );
                $asset->save;
            }
        }
        $app->call_return( fixed => 1 );
    }
}

sub is_blog_context {
    my $app = MT->instance;
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        return 1;
    }
}

sub doLog {
    my ($msg) = @_; 
    return unless defined($msg);
    require MT::Log;
    my $log = MT::Log->new;
    $log->message($msg) ;
    $log->save or die $log->errstr;
}

1;
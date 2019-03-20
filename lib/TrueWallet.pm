use strict;
use warnings;
use JSON::PP;
use Digest::SHA1 qw(sha1 sha1_hex sha1_base64);
use HTTP::Tiny;
use Data::Dumper;
my $http = HTTP::Tiny->new;

sub getToken {
	my ($user, $pass) = @_;
	my %body = (username => "$user", password => sha1_hex($user.$pass), type => 'email');
	my $response = $http->request( 'POST', 'https://mobile-api-gateway.truemoney.com/mobile-api-gateway/api/v1/signin', {
			Host => 'mobile-api-gateway.truemoney.com',
			headers => {
				'content-type' => 'application/json'
			},
			content => encode_json \%body
		}
	);
	if ($response->{success}) {
		my $tokenjson = decode_json($response->{content});
		return $tokenjson->{'data'}->{'accessToken'};		
	} else {
		print "Cannot get Token from Truewallet !\n";
	}
}

sub getProfile {
	my ($token) = @_;
	my $response = $http->request( 'GET', "https://mobile-api-gateway.truemoney.com/mobile-api-gateway/api/v1/profile/$token", {
			Host => 'mobile-api-gateway.truemoney.com'
	});

	if ($response->{success}) {
		my $profilejson = decode_json($response->{content});
		return $profilejson->{'data'};		
	} else {
		print "Cannot get Profile from Truewallet !\n";
	}
}

sub getActivity {
	my ($token,$start,$end) = @_;
	my $limit = 25;
	my $response = $http->request( 'GET', "https://mobile-api-gateway.truemoney.com/mobile-api-gateway/user-profile-composite/v1/users/transactions/history?start_date=$start&end_date=$end&limit=$limit", {
			Host => 'mobile-api-gateway.truemoney.com',
			headers => {
				'Authorization' => $token
			}	
	});

	if ($response->{success}) {
		my $activityjson = decode_json($response->{content});
		my $activity = $activityjson->{'data'}->{'activities'};
		return $activity;
	} else {
		print "Cannot get Activity from Truewallet !\n";
	}

}




sub logout {
	my ($token) = @_;
	my $response = $http->request( 'POST', "https://mobile-api-gateway.truemoney.com/mobile-api-gateway/api/v1/signout/$token", {
			Host => 'mobile-api-gateway.truemoney.com'
	});
	if ($response->{success}) {
		my $logoutjson = decode_json($response->{content});
		return $logoutjson->{'data'};		
	} else {
		print "Cannot Logout Truewallet !\n";
	}	
}
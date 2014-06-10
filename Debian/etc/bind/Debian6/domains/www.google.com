$TTL	2h
@       IN      SOA     localhost.        root.localhost. (
                                        2012062000
                                        7200
                                        1800
                                        1209600
                                        300 )
        1800        IN        NS        localhost.
        1800        IN        A        216.239.32.20 ;nosslsearch.google.com.


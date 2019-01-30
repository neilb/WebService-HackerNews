# Webservice::HackerNews

Accessing the HackerNews API from perl.

## Build

You need to install [Dist::Zilla](https://dzil.org). After that,

Install missing dependencies with

    dzil authordeps --missing | cpanm
    
And then 

    dzil build
    dzil test
    dzil install

That last one if tests are OK.

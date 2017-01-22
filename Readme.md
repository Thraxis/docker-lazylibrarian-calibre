[![Thraxis|Docker](https://raw.githubusercontent.com/thraxis/docker-templates/master/thraxis/img/thraxis-docker-medium.png)][templateurl]
[templateurl]: https://github.com/Thraxis/docker-templates

# thraxis/lazylibrarian-calibre
[![](https://images.microbadger.com/badges/version/thraxis/lazylibrarian-calibre.svg)](https://microbadger.com/images/thraxis/lazylibrarian-calibre "Get your own version badge on microbadger.com")[![](https://images.microbadger.com/badges/image/thraxis/lazylibrarian-calibre.svg)](https://microbadger.com/images/thraxis/lazylibrarian-calibre "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/thraxis/lazylibrarian-calibre.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/thraxis/lazylibrarian-calibre.svg)][hub]
[hub]: https://hub.docker.com/r/thraxis/lazylibrarian-calibre/

[LazyLibrarian][lazyurl] is a program to follow authors and grab metadata for all your digital reading needs. It uses a combination of Goodreads Librarything and optionally GoogleBooks as sources for author info and book info.  This container is based on the DobyTang fork.

[Calibre][calibreurl] is a free and open source e-book library management application developed by users of e-books for users of e-books. This container uses the CLI program calibredb to import books to the library.

[![lazylibrarian](https://raw.githubusercontent.com/thraxis/docker-templates/master/thraxis/img/lazylibrarian-calibre-icon.png)][lazyurl]
[lazyurl]: https://github.com/DobyTang/LazyLibrarian
[calibreurl]: http://calibre-ebook.com/

## Usage

```
docker create \
  --name=lazylibrarian \
  -v <path to data>:/config \
  -v <path to data>:/downloads \
  -v <path to data>:/books \
  -v <path to data>:/magazines \
  -e PGID=<gid> -e PUID=<uid>  \
  -e TZ=<timezone> \
  -p 5299:5299 \
  linuxserver/lazylibrarian
```

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`


* `-p 5299` - Port for webui
* `-v /config` Containers lazylibrarian config and database
* `-v /downloads` lazylibrarian download folder
* `-v /books` location of calibre ebook library
* `-v /magazines` location of magazine library
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
* `-e TZ` for setting timezone information, eg Europe/London

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it lazylibrarian /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application
Access the webui at `<your-ip>:5299/home`, for more information check out [LazyLibrarian][lazyurl]..

## Info

* To monitor the logs of the container in realtime `docker logs -f lazylibrarian`.

* container version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' lazylibrarian`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/lazylibrarian`

## Versions
+ **21.01.17:** Initial Release

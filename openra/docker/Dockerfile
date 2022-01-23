FROM mono

ARG OPENRA_RELEASE_VERSION=20210321
ARG OPENRA_RELEASE
ARG OPENRA_RELEASE_TYPE=release

# https://www.openra.net/download/
ENV OPENRA_RELEASE_VERSION=${OPENRA_RELEASE_VERSION:-20210321}
ENV OPENRA_RELEASE_TYPE=${OPENRA_RELEASE_TYPE:-release}
ENV OPENRA_RELEASE=${OPENRA_RELEASE:-https://github.com/OpenRA/OpenRA/releases/download/${OPENRA_RELEASE_TYPE}-${OPENRA_RELEASE_VERSION}/OpenRA-${OPENRA_RELEASE_TYPE}-${OPENRA_RELEASE_VERSION}-source.tar.bz2}

RUN set -xe; \
	apt-get update; \
	apt-get -y upgrade; \
	apt-get install -y --no-install-recommends \
				ca-certificates \
				curl \
				liblua5.1 \
				libsdl2-2.0-0 \
				libopenal1 \
				make \
				patch \
				unzip \
				xdg-utils \
				zenity \
				wget; \
	useradd -d /home/openra -m -s /sbin/nologin openra

RUN set -xe; \
	mkdir /home/openra/source; \
	cd /home/openra/source; \
	curl -L $OPENRA_RELEASE | tar xj; \
	make all RUNTIME=mono; \
	apt-get purge -y curl make patch unzip; \
	rm -rf /var/lib/apt/lists/* \
		   /var/cache/apt/archives/*

RUN set -xe; \
	mkdir -p /home/openra/lib/openra; \
	mv /home/openra/source/* /home/openra/lib/openra; \
	mkdir -p /home/openra/usr/local/lib/openra/mods/ra; \
	mkdir -p /home/openra/.config/openra \
             /home/openra/.config/openra/maps/ra/release-${OPENRA_RELEASE_VERSION} \
             /home/openra/.config/openra/Logs

ADD maps/ra /home/openra/.config/openra/maps/ra/release-${OPENRA_RELEASE_VERSION}

RUN set -xe; \
	chown -R openra:openra /home/openra/.config;

USER openra

WORKDIR /home/openra/lib/openra

CMD [ "/home/openra/lib/openra/launch-dedicated.sh" ]

LABEL org.opencontainers.image.title="OpenRA JuCh server"
LABEL org.opencontainers.image.description="Image to run a server instance for OpenRA"
LABEL org.opencontainers.image.url="https://github.com/rmoriz/openra-dockerfile"
LABEL org.opencontainers.image.documentation="https://github.com/rmoriz/openra-dockerfile#readme"
LABEL org.opencontainers.image.version=${OPENRA_RELEASE_TYPE}-${OPENRA_RELEASE_VERSION}
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.authors="Matus Chochlik"

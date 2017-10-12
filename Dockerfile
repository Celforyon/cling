FROM debian:stretch

LABEL maintainer="Alexis Pereda <alexis@pereda.fr>"
LABEL version="1.0"
LABEL description="Docker with cling"

RUN  apt update \
	&& apt install --no-install-recommends --no-install-suggests -y \
		ca-certificates cmake make wget \
		git g++ debhelper devscripts gnupg python \
	&& rm -rf /var/lib/apt/lists/*

RUN	 wget https://raw.githubusercontent.com/root-project/cling/master/tools/packaging/cpt.py \
	&& chmod +x cpt.py \
	&& ./cpt.py --check-requirements

RUN ./cpt.py --no-test --create-dev-env Release --with-workdir=/opt/cling \
	&& mv /opt/cling/$(cd /opt/cling && ls -d cling-debian*) /opt/cling/root \
	&& cp -rf /opt/cling/root/bin/cling /usr/local/bin \
	&& cp -rf /opt/cling/root/include/* /usr/local/include \
	&& cp -rf /opt/cling/root/lib/* /usr/local/lib \
	&& cp -rf /opt/cling/root/share/* /usr/local/share \
	&& cp -rf /opt/cling/builddir/lib/libclingJupyter.so* /usr/local/lib \
	&& cp -rf /opt/cling/cling-src/tools/cling/tools/Jupyter /tmp \
	\
	&& rm -rf /opt/cling /tmp/cling-obj cpt.py \
	&& mkdir /opt/cling \
	&& mv /tmp/Jupyter /opt/cling

CMD ["cling"]

FROM registry.access.redhat.com/ubi8/ubi

MAINTAINER Scott McCarty smccarty@redhat.com

RUN yum install -y procps-ng iproute net-tools

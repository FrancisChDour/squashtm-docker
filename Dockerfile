FROM openjdk:8-jre-alpine

ENV SQUASH_TM_URL="http://repo.squashtest.org/distribution/squash-tm-1.21.0.RELEASE.tar.gz"

ENV DB_TYPE="h2"
ENV DB_URL="jdbc:h2:../data/squash-tm"
ENV DB_USERNAME="sa"
ENV DB_PASSWORD="sa"

EXPOSE 8080

RUN apk add --update \
	curl && \
	rm -f /var/cache/apk/*

WORKDIR /opt
RUN curl -L ${SQUASH_TM_URL} | gunzip -c | tar x

RUN chmod +rwx squash-tm/bin/startup.sh

CMD cd /opt/squash-tm/bin && \
	sed -i "s/DB_TYPE=h2/DB_TYPE=${DB_TYPE}/" startup.sh && \
	sed -i "s?jdbc:h2:../data/squash-tm?${DB_URL}?" startup.sh && \
	sed -i "s/USERNAME=sa/USERNAME=${DB_USERNAME}/" startup.sh && \
	sed -i "s/PASSWORD=sa/PASSWORD=${DB_PASSWORD}/" startup.sh && \
	./startup.sh

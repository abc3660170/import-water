FROM openmaptiles/postgis:2.9
ENV IMPORT_DATA_DIR=/import \
    NATURAL_EARTH_DB=/import/natural_earth_vector.sqlite \
    LOCAL_IP=chentao.world \
    PORT=8080


RUN apt-get update && apt-get install -y --no-install-recommends \
      wget \
      unzip \
      sqlite3 \
    && mkdir -p $IMPORT_DATA_DIR \
    && wget --quiet http://$LOCAL_IP:$PORT/openmaptiles/water-polygons-split-3857.zip \
    && unzip -oj water-polygons-split-3857.zip -d $IMPORT_DATA_DIR \
    && rm water-polygons-split-3857.zip \
    && wget --quiet http://$LOCAL_IP:$PORT/openmaptiles/simplified-water-polygons-complete-3857.zip \
    && unzip -oj simplified-water-polygons-complete-3857.zip -d $IMPORT_DATA_DIR \
    && rm simplified-water-polygons-complete-3857.zip \
    && apt-get -y --auto-remove purge \
      wget \
      unzip \
      sqlite3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY . /usr/src/app
CMD ["./import-water.sh"]

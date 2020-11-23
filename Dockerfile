# Use the NGINX image
FROM nginx:1.19.4

# Give the image a label
LABEL "com.polr.vendor" = "Polr"
LABEL version="1.0"

# Switch to bash
SHELL ["/bin/bash", "-c"]

# Expose the SSL MQTT port
EXPOSE 8883

# Run updates necessary to provide MQTT proxying to CloudMQTT
RUN apt-get update -y && \
    apt-get install -y nginx-extras && \
    rm /etc/nginx/nginx.conf -f && \
    echo $'load_module /usr/lib/nginx/modules/ngx_stream_module.so;\n\
\n\
worker_processes auto;\n\
pid /run/nginx.pid;\n\
events {\n\
    worker_connections 768;\n\
    # multi_accept on;\n\
}\n\
stream {\n\
    upstream mqttproxy {\n\
    server humble-farmer.cloudmqtt.com:8883;\n\
    }\n\
        server {\n\
        listen 8883;\n\
        proxy_pass mqttproxy;\n\
    }\n\
}' > /etc/nginx/nginx.conf



FROM avivace/ror2server:latest
# Set the working directory
WORKDIR /root/ror2-dedicated
# Set env
ENV STEAMAPPDIR=/root/ror2-dedicated/app
# Replace entry.sh
COPY entry.sh /root/ror2-dedicated/entry.sh
# run entry.sh
RUN chmod +x /root/ror2-dedicated/entry.sh
ENTRYPOINT ["/root/ror2-dedicated/entry.sh"]

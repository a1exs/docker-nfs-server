
FROM alpine:latest

RUN apk add --no-cache --update --verbose libcap bash nfs-utils tzdata && \
    rm -rf /var/cache/apk /tmp /sbin/halt /sbin/poweroff /sbin/reboot && \
    rm -rfv /etc/idmapd.conf /etc/exports && \
    mkdir -p /var/lib/nfs/rpc_pipefs && \
    mkdir -p /var/lib/nfs/v4recovery && \
    echo "rpc_pipefs  /var/lib/nfs/rpc_pipefs  rpc_pipefs  defaults  0  0" >> /etc/fstab && \
    echo "nfsd        /proc/fs/nfsd            nfsd        defaults  0  0" >> /etc/fstab

EXPOSE 2049

HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
	CMD exportfs || exit 1

# setup entrypoint
COPY ./entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

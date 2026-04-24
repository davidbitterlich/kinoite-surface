# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/ublue-os/kinoite-main:latest

RUN rm /opt && mkdir /opt

# Copy Homebrew files from the brew image
ARG BREW_IMAGE=ghcr.io/ublue-os/brew:latest
COPY --from=${BREW_IMAGE} /system_files/ /tmp/brew_files/
RUN find /tmp/brew_files -type f -printf '/%P\0' > /tmp/brew_list.txt && \
    cp -a /tmp/brew_files/. / && \
    xargs -0 -a /tmp/brew_list.txt setfattr -h -n user.component -v "homebrew" && \
    rm -rf /tmp/brew_files /tmp/brew_list.txt

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh
    
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    /ctx/finalize.sh

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint

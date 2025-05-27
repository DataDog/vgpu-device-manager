ARG BUILDER_IMAGE

FROM ${BUILDER_IMAGE} as builder

WORKDIR /build
COPY . .
RUN make PREFIX=/artifacts cmds

FROM registry.ddbuild.io/images/nvidia-cuda-base:12.9.0

LABEL maintainers="Compute"

ENV NVIDIA_VISIBLE_DEVICES=void

COPY --from=builder /artifacts/nvidia-vgpu-dm /usr/bin/nvidia-vgpu-dm
COPY --from=builder /artifacts/nvidia-k8s-vgpu-dm /usr/bin/nvidia-k8s-vgpu-dm

ENTRYPOINT ["nvidia-k8s-vgpu-dm"]

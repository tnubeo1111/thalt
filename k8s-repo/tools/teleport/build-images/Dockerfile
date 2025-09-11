# Stage 1: Build
FROM golang:1.24-bookworm AS builder

ENV PATH="/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.cargo/bin:" 

RUN curl -sSf https://sh.rustup.rs | bash -s -- -y

RUN apt-get update && apt-get install -y \
    git \
    curl \
    make \
    pkg-config \
    libfido2-dev \
    libcbor-dev \
    libudev-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*
# Cài đặt Node.js (version 20) và kích hoạt Corepack
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && corepack enable

WORKDIR /src

COPY . .

RUN go mod download

#RUN cargo install wasm-pack

# (Tuỳ chọn) Né lỗi wasm-opt cho ironrdp nếu môi trường hay “error parsing wasm”
RUN set -eux; \
  f="web/packages/shared/libs/ironrdp/Cargo.toml"; \
  if [ -f "$f" ]; then \
    if grep -q "package.metadata.wasm-pack.profile.release" "$f"; then \
      sed -i -E 's/wasm-opt\s*=.*/wasm-opt = false/' "$f" || true; \
    else \
      printf '\n[package.metadata.wasm-pack.profile.release]\nwasm-opt = false\n' >> "$f"; \
    fi; \
  fi

#RUN make full
RUN make build/teleport
RUN make build/tsh
RUN make build/tctl
# Stage 2: Tạo image runtime
FROM public.ecr.aws/gravitational/teleport-distroless:17.7.4

# Copy library từ image builder
COPY --from=builder /usr/lib/x86_64-linux-gnu/libfido2.so.1 /usr/lib/x86_64-linux-gnu/libfido2.so.1
COPY --from=builder /usr/lib/x86_64-linux-gnu/libcbor.so.0.8 /usr/lib/x86_64-linux-gnu/libcbor.so.0.8
COPY --from=builder /usr/lib/x86_64-linux-gnu/libudev.so.1 /usr/lib/x86_64-linux-gnu/libudev.so.1
COPY --from=builder /usr/lib/x86_64-linux-gnu/libz.so.1 /usr/lib/x86_64-linux-gnu/libz.so.1

# Copy binaries từ stage builder
COPY --from=builder /src/build/teleport /usr/local/bin/teleport
COPY --from=builder /src/build/tsh /usr/local/bin/tsh
COPY --from=builder /src/build/tctl /usr/local/bin/tctl
# Nếu cần config custom, copy vào (tùy chọn)
# COPY teleport.yaml /etc/teleport/teleport.yaml

# Entry point mặc định để chạy Teleport

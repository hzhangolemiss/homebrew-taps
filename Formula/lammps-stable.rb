class LammpsStable < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://www.lammps.org"
  url "https://github.com/lammps/lammps/archive/refs/tags/stable_2Aug2023_update3.tar.gz"
  version "2Aug23.3"
  sha256 "6666e28cb90d3ff01cbbda6c81bdb85cf436bbb41604a87f2ab2fa559caa8510"
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
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"

  def install
    %w[serial mpi].each do |variant|
      system "cmake", "-S", "cmake", "-B", "build_#{variant}",
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
                        "-DPKG_LATBOLTZ=#{(variant == "mpi") ? "yes" : "no"}",
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
                        "-DBUILD_MPI=#{(variant == "mpi") ? "yes" : "no"}",
                        "-DBUILD_OMP=no",
                        "-DBUILD_SHARED_LIBS=yes",
                        "-DCMAKE_INSTALL_RPATH=#{rpath}",
                        "-DFFT=FFTW3",
                        "-DFFT_FFTW_THREADS=no",
                        "-DFFT_SINGLE=yes",
                        "-DLAMMPS_MACHINE=#{variant}",
                        "-DMPIEXEC_MAX_NUMPROCS=8",
                        "-DMPI_CXX_SKIP_MPICXX=yes",
                        "-DWITH_FFMPEG=no",
                        "-DWITH_GZIP=yes",
                        "-DWITH_JPEG=no",
                        "-DWITH_PNG=no",
                        *std_cmake_args
      system "cmake", "--build", "build_#{variant}"
      system "cmake", "--install", "build_#{variant}"
    end
  end

  test do
    system "#{bin}/lmp_serial", "-in", "#{share}/lammps/bench/in.lj"
    system "mpiexec", "-n", "1", "#{bin}/lmp_mpi", "-in", "#{share}/lammps/bench/in.lj"
    system "mpiexec", "-n", "4", "#{bin}/lmp_mpi", "-in", "#{share}/lammps/bench/in.lj"
  end
end

FROM gcc:8.1

LABEL \
  gcc.version=7.3.1 \
  gcc.release=2018-q2 \
  S112.version=6.1.0 \
  #S132.version=6.1.0 \
  #S140.version=6.1.0 \
  nrf5sdk.version=15.3.0

RUN apt-get update && apt-get install -y \
  unzip \
  vim \
  python \
  python-pip \
  && apt-get purge

WORKDIR /usr/local
RUN wget -qO- https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2 | tar -xjf -

# https://www.nordicsemi.com/eng/Products/S112-SoftDevice
WORKDIR /usr/share/S112-SoftDevice
RUN wget -qO S112-SoftDevice.zip https://www.nordicsemi.com/-/media/Software-and-other-downloads/SoftDevices/S112/s112nrf52611.zip && \
  unzip S112-SoftDevice.zip && \
  rm S112-SoftDevice.zip

# # https://www.nordicsemi.com/eng/Products/S132-SoftDevice
# WORKDIR /usr/share/S132-SoftDevice
# RUN wget -qO S132-SoftDevice.zip https://www.nordicsemi.com/-/media/Software-and-other-downloads/SoftDevices/S132/s132nrf52611.zip && \
#   unzip S132-SoftDevice.zip && \
#   rm S132-SoftDevice.zip

# # https://www.nordicsemi.com/eng/Products/S140-SoftDevice
# WORKDIR /usr/share/S140-SoftDevice
# RUN wget -qO S140-SoftDevice.zip https://www.nordicsemi.com/-/media/Software-and-other-downloads/SoftDevices/S140/s140nrf52611.zip && \
#   unzip S140-SoftDevice.zip && \
#   rm S140-SoftDevice.zip

# https://www.nordicsemi.com/eng/Products/Bluetooth-low-energy/nRF5-SDK
WORKDIR /usr/share/nRF5-SDK
RUN wget -qO nRF5-SDK.zip https://www.nordicsemi.com/-/media/Software-and-other-downloads/SDKs/nRF5/Binaries/nRF5SDK153059ac345.zip && \
  unzip nRF5-SDK.zip && \
  rm nRF5-SDK.zip

# https://www.nordicsemi.com/eng/Products/Bluetooth-low-energy/nRF5-SDK-for-HomeKit
# The nRF5 SDK for HomeKit is available to MFI licensees only

# Setting up the development kit for nRF52832
# https://infocenter.nordicsemi.com/index.jsp?topic=%2Fcom.nordic.infocenter.nrf52%2Fdita%2Fnrf52%2Fdevelopment%2Fsetting_up_new.html

# Include nrfutil
RUN pip install nrfutil

# Include the Nordic Command Line Tools
# https://www.nordicsemi.com/eng/Products/Bluetooth-low-energy/nRF52832/nRF5x-Command-Line-Tools-Linux64
WORKDIR /usr/local/nRF5x
RUN wget https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF-command-line-tools/sw/Versions-10-x-x/10-11-1/nRFCommandLineTools10111Linuxamd64tar.gz && \
  tar -xf nRFCommandLineTools10111Linuxamd64tar.gz 
RUN tar -xf nRF-Command-Line-Tools_10_11_1.tar
  # rm JLink_Linux_V686f_x86_64.deb && \
  # rm JLink_Linux_V686f_x86_64.tgz && \
  # rm nRF-Command-Line-Tools_10_11_1_Linux-amd64.deb && \
  # rm nRFCommandLineTools10111Linuxamd64tar.gz && \
  # rm nRF-Command-Line-Tools_10_11_1.tar && \
  # rm README.txt

# https://gustavovelascoh.wordpress.com/2017/01/23/starting-development-with-nordic-nrf5x-and-gcc-on-linux/
COPY Makefile.posix /usr/share/nRF5-SDK/nRF5_SDK_15.3.0_59ac345/components/toolchain/gcc/Makefile.posix

ENV \
  PATH="/usr/local/gcc-arm-none-eabi-7-2018-q2-update/bin/:${PATH}:/usr/local/nRF5x/nrfjprog:/usr/local/nRF5x/mergehex" \
  SDK_ROOT="/usr/share/nRF5-SDK/nRF5_SDK_15.3.0_59ac345" \
  S112_ROOT="/usr/share/S112-SoftDevice/" \
  S112_IMAGE="/usr/share/S112-SoftDevice/s112_nrf52_6.1.0_softdevice.hex" \
  BUILD_PLACE="/usr/share/nRF5-SDK/nRF5_SDK_15.3.0_59ac345/examples/ble_peripheral"
  # S132_ROOT="/usr/share/S132-SoftDevice/" \
  # S132_IMAGE="/usr/share/S132-SoftDevice/s132_nrf52_6.1.0_softdevice.hex" \
  # S140_ROOT="/usr/share/S140-SoftDevice/" \
  # S140_IMAGE="/usr/share/S140-SoftDevice/s140_nrf52_6.1.0_softdevice.hex"

WORKDIR /build/app

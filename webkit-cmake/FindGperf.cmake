# * Find gperf This module looks for gperf. This module defines the following
#   values: GPERF_EXECUTABLE: the full path to the gperf tool. GPERF_FOUND: True
#   if gperf has been found.

include(FindCygwin)

find_program(GPERF_EXECUTABLE gperf ${CYGWIN_INSTALL_PATH}/bin)

# handle the QUIETLY and REQUIRED arguments and set GPERF_FOUND to TRUE if all
# listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Gperf DEFAULT_MSG GPERF_EXECUTABLE)

mark_as_advanced(GPERF_EXECUTABLE)

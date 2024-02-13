# read metadata from magisk module.prop (INPUT_FILE) and write to file (OUTPUT_FILE)

file(READ ${INPUT_FILE} module_prop_content)

string(REGEX MATCH "version=([^\n]*)" version_match "${module_prop_content}")
if (DEFINED version_match)
    string(REPLACE "version=" "" version ${version_match})
    message(STATUS "version: ${version}")
endif()

string(REGEX MATCH "versionCode=([^\n]*)" version_code_match "${module_prop_content}")
if (DEFINED version_code_match)
    string(REPLACE "versionCode=" "" versionCode ${version_code_match})
    message(STATUS "versionCode: ${versionCode}")
endif()

set(jsonContent "{\"version\": \"${version}\", \"versionCode\": ${versionCode}, \"zipUrl\": \"https://raw.githubusercontent.com/XSheeee/freezeitRelease/main/${zipFile}\", \"changelog\": \"https://raw.githubusercontent.com/XSheeee/freezeitRelease/main/changelog.md\"\n}")

file(WRITE ${OUTPUT_FILE} "${jsonContent}")
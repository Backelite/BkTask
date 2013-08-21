#!/usr/bin/env bash

set -x
set -e

proj_dir="$(dirname "$(dirname "$0")")"
proj_dir=${proj_dir/#.\//$PWD/}
root_dir="$(dirname "${proj_dir}")"
(
cd "${root_dir}"
proj_file="$(find "${proj_dir}" -depth 1 -name '*.xcodeproj' | head -1)"
#to improve
target_name="$(xcodebuild -list -project "${proj_file}" | grep '(Framework)' | head -1 | sed 's/ *//')"
build_dir="${TMPDIR}/$(basename ${proj_file} .xcodeproj)"
log_file="${build_dir}/"
build_dir_sim="${build_dir}/build-iphonesimulator"
build_dir_ios="${build_dir}/build-iphoneos"
mkdir -p "${build_dir}" "${build_dir_sim}" "${build_dir_ios}"
build_params=(-project "${proj_file}" -target "${target_name}" FRAMEWORK_SEARCH_PATHS="\"${root_dir}\" \$(inherited)")

xcodebuild "${build_params[@]}" TARGET_BUILD_DIR="${build_dir_sim}" -sdk iphonesimulator > "${build_dir}/iphonesimulator.log"
xcodebuild "${build_params[@]}" TARGET_BUILD_DIR="${build_dir_ios}" -sdk iphoneos > "${build_dir}/iphoneos.log"
framework_name="$(basename "$(find "${build_dir_ios}" -name '*.framework' -depth 1 | head -1)" .framework)"

mv "${build_dir_ios}/${framework_name}.framework/Versions/A/${framework_name}" "${build_dir_ios}/${framework_name}.framework/Versions/A/${framework_name}-ios"
mv "${build_dir_sim}/${framework_name}.framework/Versions/A/${framework_name}" "${build_dir_ios}/${framework_name}.framework/Versions/A/${framework_name}-sim"
pushd "${build_dir_ios}/${framework_name}.framework/Versions/A/"
lipo -create -output "${framework_name}" "${framework_name}-ios" "${framework_name}-sim"
rm "${framework_name}-sim" "${framework_name}-ios"
popd

if [ -e "${root_dir}/${framework_name}.framework" ]; then
	mv "${root_dir}/${framework_name}.framework" "${root_dir}/${framework_name}-$(stat -t '%Y%m%d-%H:%M:%S' -f '%Sc' "${root_dir}/${framework_name}.framework").framework"
fi
mv "${build_dir_ios}/${framework_name}.framework" "${root_dir}"

# xcodebuild -workspace BKitProto.xcworkspace -scheme 'BkCore (Framework)' -sdk iphonesimulator TARGET_BUILD_DIR=${PWD}/build-simu
)

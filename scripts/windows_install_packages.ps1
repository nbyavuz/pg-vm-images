$ErrorActionPreference = "Stop"

$filepath = "c:\vcpkg"
$binary_cache_path = "$filepath\binary_cache\"
$cirrus_build_id = $Env:CIRRUS_BUILD_ID

vcvarsall.bat x64
git clone --depth 1 https://github.com/Microsoft/vcpkg.git "$filepath"
cd "$filepath"

# git remote add personal https://github.com/anarazel/vcpkg.git
# git fetch personal
# git reset --hard personal/tools

mkdir -p binary_cache, downloads
$ARTIFACT_URL="https://api.cirrus-ci.com/v1/artifact/build/$cirrus_build_id/windows-ci-vs-2019/vcpkg_cache/vcpkg_cache_dir/vcpkg_cache_upload.zip"
echo "URL IS $ARTIFACT_URL"
curl.exe -fsSLO ${ARTIFACT_URL}

echo "Extracting the cache"
7z.exe x "vcpkg_cache_upload.zip" -o"$binary_cache_path"

echo "Before install, cache ="
dir "$filepath\binary_cache\"

.\bootstrap-vcpkg.bat -disableMetrics
.\vcpkg.exe install --debug --binarysource=files,$binary_cache_path,readwrite --triplet=x64-windows pkgconf

echo "After install, cache ="
dir "$binary_cache_path"
dir "$binary_cache_path\0e\"


# (rm -r buildtrees) -or $true
dir
(du -sh *) -or $true
(find . -name '*.exe' -or -name '*.pc') -or $true

$pkg_paths = "${filepath}\installed\x64-windows\tools\pkgconf;${filepath}\installed\x64-windows\tools\gettext\bin;${filepath}\installed\x64-windows\debug\lib;${filepath}\installed\x64-windows\debug\bin;"

[Environment]::SetEnvironmentVariable('PATH', $pkg_paths + [Environment]::GetEnvironmentVariable('PATH', 'Machine'), 'Machine')
[Environment]::SetEnvironmentVariable('PKG_CONFIG', 'pkgconf', 'Machine')
[Environment]::SetEnvironmentVariable('PATH',  'C:\winflexbison;' + [Environment]::GetEnvironmentVariable('PATH', 'Machine'), 'Machine')

#!/bin/sh

"../../output/bin/bmfs" --disk "../../output/baremetal-os.img" --offset 32KiB rm -f "Applications/test.app"
"../../output/bin/bmfs" --disk "../../output/baremetal-os.img" --offset 32KiB cp "test" "Applications/test.app"

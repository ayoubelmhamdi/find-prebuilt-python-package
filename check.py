#!/usr/bin/env python3

import sys
from pip._internal.utils.compatibility_tags import get_supported


import re

def parse_wheel_filename(filename):
    # Pattern to match wheel filename components
    pattern = r'([a-zA-Z0-9_.-]+)-([0-9.]+)-([a-zA-Z0-9_]+)-([a-zA-Z0-9_]+)-(.+)\.whl'
    
    # Remove quotes
    filename = filename.strip('"')
    
    match = re.match(pattern, filename)
    
    if match:
        package_name = match.group(1)
        version = match.group(2)
        python_tag = match.group(3)
        abi_tag = match.group(4)
        platform_tag = match.group(5)

        return package_name , version, python_tag, abi_tag, platform_tag

    else:
        return None, None, None, None, None


# filename = '"numpy-2.2.4-cp310-cp310-macosx_10_9_x86_64.whl"'
filename = sys.argv[1]
package_name , version, python_tag, abi_tag, platform_tag = parse_wheel_filename(filename)


device_tags = get_supported()

is_compatible = any(
    tag.interpreter == python_tag
    and tag.abi == abi_tag
    and tag.platform == platform_tag
    for tag in device_tags
)

if is_compatible:
    print(f"{filename} is Compatible")
# else:
#     print(f"{filename} Compatible: {is_compatible}")

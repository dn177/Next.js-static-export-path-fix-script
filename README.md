# Next.js-static-export-path-fix-script
Run this script to adjust the paths to work correctly when uploaded as static assets after a static export in Next.js.
This scripts prepends "." to all relevant paths that dont contain "http(s)://" in the root folder and "../" for every level of depth in a subdirectory, resulting in proper relative paths.

You can also add this as script in your package.json and customize the command. This example assumes that the script is placed in the same folder as the package.json file:
```json
 "scripts": {
    "dev": "next dev",
    "build": "next build",
    "export": "next build && bash ./path_fix.sh",
    "start": "next start",
    "lint": "next lint"
  },
```

Note:
I can only assure that this script runs in unix shells. Windows users might need to install further packages to make the "sed" as well as other commands work and adjust the script.

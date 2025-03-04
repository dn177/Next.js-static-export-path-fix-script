# Next.js-static-export-path-fix-script
Run this script to adjust the paths to work correctly when uploaded as static assets after a static export in Next.js.
Since this script was written for SPAs, you might need to add further .html files and create further backups.

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
